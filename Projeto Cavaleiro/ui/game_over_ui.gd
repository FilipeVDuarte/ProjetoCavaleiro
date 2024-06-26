class_name GameOverUI
extends CanvasLayer

@onready var time_label: Label = %QT_Tempo
@onready var enemy_label: Label = %QT_Inimigos
@onready var iMoedas_label: Label = %QT_Itens_Moedas
@onready var iComida_label: Label = %QT_Itens_Comidas

@export var restart_delay: float = 4.0
var restart_cooldown: float

@onready var varia_game_over:Panel = %VariaGameOver 
var panels = []

func _ready():
	time_label.text = GameManager.time_elapsed_string
	enemy_label.text = str(GameManager.enemy_defeated_counter)
	iMoedas_label.text = str(GameManager.coin_counter)
	iComida_label.text = str(GameManager.vida_counter) 
	restart_cooldown = restart_delay
	
	# Inicializa os Panels de game over
	for child in varia_game_over.get_children():
		if child is Panel:
			panels.append(child)
				
	# Oculta todos os Panels inicialmente
	for panel in panels:
		panel.hide()
		
	show_random_panel()

func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		restart_game()
		

func restart_game():
	GameManager.reset()
	get_tree().change_scene_to_file("res://menus/menu_inicial.tscn")

func show_random_panel():
	# Oculta todos os Panels
	for panel in panels:
		panel.hide()
	
	# Escolhe um Panel aleatório e o exibe
	var random_panel = panels[randi() % panels.size()]
	random_panel.show()
