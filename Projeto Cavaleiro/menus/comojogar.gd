extends Control


func _ready():
	# Referência ao AnimationPlayer
	var animation_player = $AnimationPlayer

	# Verificar se a animação atual é "RESET" e tocar "default" se necessário
	if animation_player.current_animation == "RESET":
		animation_player.play("default")
	else:
		animation_player.play("default")
	


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://menus/menu_inicial.tscn")
