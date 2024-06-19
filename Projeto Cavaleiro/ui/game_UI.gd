extends CanvasLayer

@onready var time_label:Label = %LabelTempo
@onready var vida_label:Label = %LabelVida
@onready var moeda_label:Label = %LabelMoedas

func _process(delta: float):
	#Update Labels
	time_label.text = GameManager.time_elapsed_string
	vida_label.text = str(GameManager.vida_counter)
	moeda_label.text = str(GameManager.coin_counter)
