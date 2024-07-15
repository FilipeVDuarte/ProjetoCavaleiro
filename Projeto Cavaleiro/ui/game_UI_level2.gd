class_name GameUIL2
extends CanvasLayer

@onready var time_label:Label = %LabelTempo
@onready var vida_label:Label = %LabelVida
@onready var moeda_label:Label = %LabelMoedas
@onready var quest_label:Label = %LabelQuest
@onready var quest_total_label:Label = %LabelQuest_total
@onready var enemy_counter_label:Label = %LabelECounter

@onready var panel_quest: Panel = $ReferenceRect/Panel_Quest

func _process(_delta: float):
	# Update Labels
	time_label.text = GameManager.time_elapsed_string
	vida_label.text = str(GameManager.vida_counter)
	moeda_label.text = str(GameManager.coin_counter)
	quest_label.text = str(GameManager.quest_counter)
	quest_total_label.text = str(GameManager.total_quest)
	enemy_counter_label.text = str(GameManager.enemy_defeated_counter)
	
	var total_enemies_str:int = 30
	
	# Condicional para quest
	panel_quest.visible = GameManager.enemy_defeated_counter >= total_enemies_str
