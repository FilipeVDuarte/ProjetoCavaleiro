class_name Level
extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
# Adiciona uma variável para a cena do boss específica desta fase
@export var boss_scene: PackedScene  
@export var total_quest_amount: int = 4  # Número total de objetivos a serem coletados nesta fase

@onready var is_level_with_quests: bool = true
@onready var SceneTransitionAnimation = $scene_transition/AnimationPlayer

func _ready():
	SceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	SceneTransitionAnimation.play("fade_out")
	GameManager.game_over.connect(trigger_game_over)
	GameManager.start_timer() # Inicia a contagem do tempo
	GameManager.total_quest = total_quest_amount  # Atualiza o total de quests no GameManager
	
func get_total_quest_amount() -> int:
	return total_quest_amount

func _process(_delta) -> void:
	if GameManager.quest_counter >= total_quest_amount:
		SceneTransitionAnimation.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		GameManager.reset_quest()
		get_tree().change_scene_to_file("res://main_boss.tscn")
		
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
