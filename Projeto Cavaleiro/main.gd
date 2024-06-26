class_name Level
extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene


func _ready():
	GameManager.game_over.connect(trigger_game_over)
	GameManager.start_timer() # Inicia a contagem do tempo

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
