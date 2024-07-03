class_name LevelBoss
extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
var is_level_with_quests: bool = false
@onready var boss = $Capiguara

func _ready():
	GameManager.game_over.connect(trigger_game_over)
	GameManager.start_timer() # Inicia a contagem do tempo
	
func _process(delta) -> void:
	if not is_instance_valid(boss):
		# Carregar o próximo nível
		get_tree().change_scene_to_file("res://level_2.tscn")
		
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
