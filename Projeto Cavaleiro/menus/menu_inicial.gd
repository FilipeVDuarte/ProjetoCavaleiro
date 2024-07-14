extends Control

func _ready():
	# Referência ao AnimationPlayer
	var animation_player = $AnimationPlayer

	# Verificar se a animação atual é "RESET" e tocar "default" se necessário
	if animation_player.current_animation == "RESET":
		animation_player.play("default")
	else:
		animation_player.play("default")
	
	$VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_como_jogar_button_pressed():
	get_tree().change_scene_to_file("res://menus/comojogar.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
