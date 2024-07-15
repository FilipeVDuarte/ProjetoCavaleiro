class_name Level2
extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
@export var boss_scene: PackedScene  
@export var total_quest_amount: int = 3  # Número total de objetivos a serem coletados nesta fase

@onready var is_level_with_quests: bool = true
@onready var quests_ui: Panel = $"Game UI/ReferenceRect/Panel_Quest"
@onready var quest_group: Node2D = %Quests
@onready var SceneTransitionAnimation = $scene_transition/AnimationPlayer

func _ready():
	GameManager.enemy_defeated_counter = 0
	SceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	SceneTransitionAnimation.play("fade_out")
	GameManager.game_over.connect(trigger_game_over)
	GameManager.start_timer() # Inicia a contagem do tempo
	GameManager.total_quest = total_quest_amount  # Atualiza o total de quests no GameManager
	quest_group.visible = false

	# Conecta o sinal de mudança de visibilidade do quests_ui
	quests_ui.connect("visibility_changed", Callable(self, "_on_quests_ui_visibility_changed"))

func get_total_quest_amount() -> int:
	return total_quest_amount

func _process(delta) -> void:
	if GameManager.quest_counter >= total_quest_amount:
		SceneTransitionAnimation.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://level2_boss.tscn")
	
func _exit_tree():
	GameManager.stop_timer() # Para a contagem do tempo

func trigger_game_over():
	# Deletar Game UI
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	# Criar Game Over UI
	var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
	add_child(game_over_ui)

func _on_quests_ui_visibility_changed():
	quest_group.visible = quests_ui.visible
