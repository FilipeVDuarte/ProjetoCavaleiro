class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
var mob_per_minute: float = 60.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D
var cooldown: float = 0.0


func _process(delta: float):
	#Ignorar Game Over
	if GameManager.is_game_over: return
	
	# Temporizador (cooldown)
	cooldown -= delta
	if cooldown > 0: return
	
	# Se mob_per_minute for 0, não criar novos monstros
	if mob_per_minute <= 0: return
	
	# Frequência: Monstro por minuto
		# 60 Mob/min = 1 mob/seg
		# 120 Mob/min = 2 mob/seg
		# Intervalo em segundos entre mobs => 60 / Frequência
		# 60 / 60 = 1
		# 60 / 120 = 0.5
		# 60 / 30 = 2
	var interval = 60.0 / mob_per_minute
	cooldown = interval
	
	#Checar ponto válido
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	var result:Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty(): return
	
	#Instancia criatura aletória
		# - Pegar Criatura aleatória
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	# - Instaciar cena
	var creature = creature_scene.instantiate()
	# - Colocar na posição
	creature.global_position = get_point()
	# - Definir Parentesco
	get_parent().add_child(creature)

func get_point() -> Vector2:
	# Random Float, retorna um valor aleatório dentre 0.0 e 1.0
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position

# .position é usado pra uma ocasião local
# quando for necessário utilizar a posição em relação a cena, use global_position
