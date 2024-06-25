class_name Enemy
extends Node2D

@export_category("Vida")
@export var health: int = 10
@export var death_prefab: PackedScene
var damage_digit_prefab: PackedScene

@onready var damage_digit_marker = $DamageDigitMarker

@export_category("Drops")
@export var drop_chance: float = 0.5
@export var drop_itens: Array[PackedScene]
@export var drop_chances: Array[float]

signal damaged

func _ready():
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")

func damage(amount: int) -> void:
	health -= amount
	print("Inimigo recebeu dano ", amount, " total de ", health)
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	emit_signal("damaged", amount)
	
	#Criar DamageDigit
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)
	
		
	if health <= 0:
		die()

func _on_enemy_damaged(amount: int) -> void:
	# Aqui você pode adicionar qualquer lógica
	# que precisa ser executada quando o inimigo é danificado
	print("Sinal de dano recebido com valor: ", amount)

func die() -> void:
	#Caveira
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	#Drop
	if randf() <= drop_chance:
		drop_item()

	#Incrementar contador
	GameManager.enemy_defeated_counter += 1
	
	queue_free()

func drop_item() -> void:
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)


func get_random_drop_item() -> PackedScene:
	#Listas com 1 item
	
	if drop_itens.size() == 1:
		return drop_itens[0]
	
	#@export var drop_itens: Array[PackedScene]
	#@export var drop_chances: Array[float]
	#Calcular Chance Máxima
	var max_chances: float = 0.0
	@warning_ignore("shadowed_variable", "shadowed_variable")
	for drop_chance in drop_chances:
		max_chances += drop_chance
	
	#Joga Dado
	var random_value = randf() * max_chances
	
	
	#Gira Roleta
	var needle: float = 0.0
	for i in drop_itens.size():
		@warning_ignore("shadowed_variable")
		var drop_item = drop_itens[i]
		
		@warning_ignore("shadowed_variable", "incompatible_ternary")
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	
	return drop_itens[0]
