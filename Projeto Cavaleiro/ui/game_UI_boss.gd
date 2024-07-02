class_name GameUIBoss
extends CanvasLayer

@onready var time_label:Label = %LabelTempo
#@onready var vida_label:Label = %LabelVida
#@onready var moeda_label:Label = %LabelMoedas
@onready var quest_label:Label = %LabelQuest
#@onready var cooldown_ritual:ProgressBar = %CooldownRitual
#@onready var quest_total_label:Label = %LabelQuest_total

func _process(_delta: float):
	#Update Labels
	time_label.text = GameManager.time_elapsed_string
#	vida_label.text = str(GameManager.vida_counter)
#	moeda_label.text = str(GameManager.coin_counter)
#	quest_label.text = str(GameManager.quest_counter)
#	quest_total_label.text = str(GameManager.total_quest)
#	cooldown_ritual.value = GameManager.cooldown_ritual
