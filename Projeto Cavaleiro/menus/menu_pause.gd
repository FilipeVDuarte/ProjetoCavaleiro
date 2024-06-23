extends Control

@onready var main_scene = $"../../"

func _on_retormar_pressed():
	main_scene.pause_Menu()

func _on_sair_pressed():
	get_tree().change_scene_to_file("res://menus/menu_inicial.tscn")
