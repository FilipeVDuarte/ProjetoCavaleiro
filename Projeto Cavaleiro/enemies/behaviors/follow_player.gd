extends Node

@export var speed: float = 1

var enemy: Enemy
var sprite: Sprite2D

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("Sprite2D")
	enemy.health
	
func _physics_process(_delta: float) -> void:
	#Ignorar Game Over
	if GameManager.is_game_over: return
	
	# Posição do Player
	var player_position = GameManager.player_position
	
	#Calcula a diferença entre o Player e o inimigo
	var difference = player_position - enemy.position
	
	#Normaliza a diferença dentre -1 e 1
	var input_vector = difference.normalized()
	
	#Define a velocidade
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
	
	# Girar sprite
	if input_vector.x > 0:
		sprite.flip_h = true	
	elif input_vector.x < 0:
		sprite.flip_h = false
		
