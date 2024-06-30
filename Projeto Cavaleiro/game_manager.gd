extends Node

@onready var current_level: Level = get_tree().current_scene  # Obtém uma referência ao nó Level atual

signal game_over
signal all_objectives_collected

var player: Player 
var player_position: Vector2
var is_game_over: bool = false

var time_elapsed:float = 0.0
var time_elapsed_string: String
var vida_counter:int = 0
var coin_counter:int = 0
var enemy_defeated_counter: int = 0
var quest_counter: int = 0
var total_quest: int = 0 
var ritual_cooldown: float = 0.0
var cooldown_ritual: float = 0.0

# Variável para verificar se a cena Level está rodando
var is_level_running: bool = false

func _ready():
	if current_level:
		total_quest = current_level.total_quest_amount
		print("Nessa fase tem um total de ", total_quest, " Objetivos")
	else:
		print("Nenhuma cena de Level encontrada!")

func _process(delta:float) -> void:
	if is_level_running:
		time_elapsed += delta
		var time_elapsed_in_seconds: int = floori(time_elapsed)
		var seconds: int = time_elapsed_in_seconds % 60
		var minutes: int = time_elapsed_in_seconds / 60
		time_elapsed_string = "%02d:%02d" % [minutes, seconds]
		
		# Floor - Arredonda valor pra baixo + i Retorna valor inteiro
		# Rounded - Arredonda pra baixo ou pra cima depende do valor
		# ceil - Arredonda pra cima
		# Quando começa com %, significa que vamos passar uma variavel para texto
		# o d significa que é um digito, que estamos passando um numero inteiro
		# e o 02 significa que vamos passar dois numeros
	
	#cooldown_ritual = player.cooldown_ritual
		
func end_game() -> void:
	if is_game_over: return
	is_game_over = true
	game_over.emit()

func reset() -> void:
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	
	time_elapsed = 0.0
	time_elapsed_string = "00:00"
	vida_counter = 0
	coin_counter = 0
	enemy_defeated_counter = 0
	quest_counter = 0
	
	for connection: Dictionary in game_over.get_connections():
		game_over.disconnect(connection.callable)

func start_timer() -> void:
	is_level_running = true

func stop_timer() -> void:
	is_level_running = false

func on_objective_collected(amount: int) -> void:
	quest_counter += amount
