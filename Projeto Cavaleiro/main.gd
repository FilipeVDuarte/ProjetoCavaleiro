extends Node2D

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene


@onready var menu_pause = %Menu_Pause

var paused = false

func _ready():
	GameManager.game_over.connect(trigger_game_over)

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		pause_Menu()

func pause_Menu():
	if paused:
		menu_pause.hide()
		Engine.time_scale = 1
	else:
		menu_pause.show()
		Engine.time_scale = 0
		
	paused = !paused
func trigger_game_over():
	#Deletar Game UI
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	#Criar Game Over UI
	var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
	add_child(game_over_ui)
