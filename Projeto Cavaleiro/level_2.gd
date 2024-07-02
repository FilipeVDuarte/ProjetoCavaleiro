class_name Level2 
extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
# Adiciona uma variável para a cena do boss específica desta fase
@export var boss_scene: PackedScene  
@export var total_quest_amount: int = 3  # Número total de objetivos a serem coletados nesta fase

@onready var is_level_with_quests: bool = true
@onready var quests_group:Node2D = $Quests

func _ready():
	GameManager.game_over.connect(trigger_game_over)
	GameManager.start_timer() # Inicia a contagem do tempo
	GameManager.total_quest = total_quest_amount  # Atualiza o total de quests no GameManager
	
func get_total_quest_amount() -> int:
	return total_quest_amount

func _process(delta) -> void:
	if GameManager.quest_counter >= total_quest_amount:
		print("trigger boss")
		get_tree().change_scene_to_file("res://level2_boss.tscn")

	quests_group.visible = false
	if GameManager.enemy_defeated_counter >= 30:
		quests_group.visible = true

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

