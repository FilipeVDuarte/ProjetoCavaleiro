extends CanvasLayer

@onready var time_label:Label = %LabelTempo
@onready var vida_label:Label = %LabelVida
@onready var moeda_label:Label = %LabelMoedas
@onready var quest_label:Label = %LabelQuest
@onready var cooldown_ritual:ProgressBar = %CooldownRitual

func _process(_delta: float):
	#Update Labels
	time_label.text = GameManager.time_elapsed_string
	vida_label.text = str(GameManager.vida_counter)
	moeda_label.text = str(GameManager.coin_counter)
	quest_label.text = str(GameManager.quest_counter)
	cooldown_ritual.value = GameManager.cooldown_ritual
