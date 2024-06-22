extends Control

@onready var main = "res://main.tscn"

func _on_retormar_pressed():
	main.pauseMenu()

func _on_sair_pressed():
	get_tree().change_scene_to_file("res://menu_inicial.tscn")
