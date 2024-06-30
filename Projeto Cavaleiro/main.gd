class_name Level
extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
# Adiciona uma variável para a cena do boss específica desta fase
@export var boss_scene: PackedScene  
@export var total_quest_amount: int = 4  # Número total de objetivos a serem coletados nesta fase

func _ready():
	GameManager.game_over.connect(trigger_game_over)
	GameManager.start_timer() # Inicia a contagem do tempo
	

func _process(delta) -> void:
	if GameManager.quest_counter >= total_quest_amount:
		print("trigger boss")
		get_tree().change_scene_to_file("res://menus/menu_inicial.tscn")
		
func _exit_tree():
	GameManager.stop_timer() # Para a contagem do tempo

func trigger_game_over():
	#Deletar Game UI
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	#Criar Game Over UI
	var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
	add_child(game_over_ui)

# func trigger_boss_level() -> void:
#	if GameManager.quest_counter:
#		GameManager.quest_counter = total_quest_amount
#		print("trigger boss")
#		get_tree().change_scene_to_file("res://menus/menu_inicial.tscn")
