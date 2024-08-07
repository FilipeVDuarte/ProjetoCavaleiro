class_name Player
extends CharacterBody2D

@export_category("Moviment")
@export var speed: float = 300.0

@export_category("Dano")
@export var damage: int = 2

@export_category("Ritual")
@export var ritual_damage: int = 0
@export var ritual_interval: float = 0.6
@export var ritual_cooldown: float = 0.6
@export var ritual_scene:  PackedScene = preload("res://misc/ritual.tscn")

@export_category("Health")
@export var health: int = 50
@export var max_health: int = 50
@export var death_prefab: PackedScene = preload("res://misc/big_skull.tscn" )

@export_category("Itens")
@export var item_cc:int = 0
@export var item_qc:int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area2D = $Attack_Area
@onready var slash: Sprite2D = $Slash
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_progress_bar: ProgressBar = $HealthProgressBar
@onready var current_scene = get_tree().current_scene

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var cooldown_ritual: float = 0.0

signal meat_collected(value: int)
signal mark_collected(value: int)
signal coin_collected(value: int)
signal damaged_amount(value: int)
signal quest_collected(value: int)

func _ready():
	GameManager.player = self
	meat_collected.connect(func(value: int): GameManager.vida_counter += 1)
	@warning_ignore("unused_parameter")
	coin_collected.connect(func(value: int): GameManager.coin_counter += 1)
	quest_collected.connect(func(value: int): GameManager.quest_counter += 1)

func _process(delta: float) -> void:
	GameManager.player_position = position
	
	# Ler inputs
	read_input()
	
	#Processar ataque
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("shoot"):
		attack()
		
	# Processar animação de andar e parado
	play_animation()
	if not is_attacking:
		rotate_sprite()
		
	#Processar dano
	update_hitbox_detection(delta)
	
	if current_scene:
		current_scene = "res://level_2.tscn"
		damage = 5
	
#	update_ritual(delta)
#	#Ritual
#	if Input.is_action_just_pressed("shoot_b"):
#		if ritual_cooldown >= 0:
#			return
#		else:
#			print("botao 2 ok")
#			ritual(delta)
			
	
	#Atualizar Barra de Vida
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health

func _physics_process(_delta: float) -> void: # Se mexe com física colocar aqui
	# Modificar a velocidade
	var target_velocity = input_vector * speed  # Multiplicando pelo speed
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()  # Passando o velocity como argumento e o vetor de direção

func update_attack_cooldown(delta: float) -> void:
	# Atualizar temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta 
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			slash.visible = false
			animation_player.play("idle")
		else: 
			is_attacking = true

func update_ritual(delta: float) -> void:
	#Atualizar temporizador
	ritual_cooldown -= delta
	print(ritual_cooldown)
	if ritual_cooldown > 0: return
	cooldown_ritual = ritual_cooldown
	#Resetar Temporizador
	ritual_cooldown = ritual_interval
	
func ritual(delta: float) -> void:
	#Criar Ritual || instanciou e colou no player
	@warning_ignore("shadowed_variable")
	var ritual = ritual_scene.instantiate()
	ritual_damage = ritual.damage_amount
	add_child(ritual)

func read_input() -> void:
	# Obter o input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	#Apagar deadzone do input vector
	var _deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	
	# Atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_animation() -> void:
		# Tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("walk")
			else:
				animation_player.play("idle")

func rotate_sprite() -> void:
# Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
		slash.flip_h = false
		#Desmarcar Flip.h do Sprite 2D
		pass
	elif input_vector.x < 0:
		sprite.flip_h = true
		slash.flip_h = true
		#Marcar Flip.hh  do Sprite 2D
		pass

func attack() -> void:
	if is_attacking:
		return
	
	if is_running:
		animation_player.play("walk_escudo")
	else:
		animation_player.play("idle_escudo")
		
	attack_cooldown = 0.6
	
	is_attacking =  true

func deal_damage_to_enemies() -> void:
	var bodies = attack_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies") or body.is_in_group("enemies_n1") or body.is_in_group("enemies_n2") or body.is_in_group("enemies_n3"):
			var enemy: Enemy = body
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
				
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				enemy.damage(damage)
				$Audio_Dano.play()

func update_hitbox_detection(delta: float) -> void:
	#Temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	#Frequência (2x por segundo)
	hitbox_cooldown = 0.5
	
	#Detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var _enemy: Enemy = body
			var damage_recebido_amount = 2
			damage_to_player(damage_recebido_amount)
		if body.is_in_group("enemies_n1"):
			var _enemy: Enemy = body
			var damage_recebido_amount = 2
			damage_to_player(damage_recebido_amount)
		if body.is_in_group("enemies_n2"):
			var _enemy: Enemy = body
			var damage_recebido_amount = 4
			damage_to_player(damage_recebido_amount)
		if body.is_in_group("enemies_n3"):
			var _enemy: Enemy = body
			var damage_recebido_amount = 6
			damage_to_player(damage_recebido_amount)	
		if body.is_in_group("boss"):
			var _enemy: Enemy = body
			var damage_recebido_amount = 10
			damage_to_player(damage_recebido_amount)

func damage_to_player(amount: int) -> void:
	if health <= 0: return
	health -= amount
	print("PLayer recebeu dano ", amount, ", Vida: ", health, "/", max_health )
	
	#Animação de tomar dano
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	var hurt = $Audio_Hurt
	hurt.playing = true
	
	if health <= 0:
		die()

func die() -> void:
	GameManager.end_game()
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	var death = $Audio_Death
	death.playing = true
	await get_tree().create_timer(0.8).timeout
	print("Player morreu")
	queue_free()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	print("Player recebeu cura de ", amount, ". A vida total é de ", health, "/", max_health)
	$Audio_VidaRegen.play()
	return health

func coin_collect(coin_amount:int) -> void:
	item_cc += coin_amount
	$Audio_ColetaMoeda.play()
	print("jogador achou ", coin_amount, " total de ", item_cc)

func quest_collect(quest_amount: int) -> void:
	item_qc += quest_amount
	quest_collected.emit(quest_amount)
	$Audio_ColetaMoeda.play()
