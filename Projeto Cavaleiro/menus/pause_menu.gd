extends Control

var _is_paused:bool = false:
	set = set_paused
	

func _ready():
	# Referência ao AnimationPlayer
	var animation_player = $AnimationPlayer

	# Verificar se a animação atual é "RESET" e tocar "default" se necessário
	if animation_player.current_animation == "RESET":
		animation_player.play("default")
	else:
		animation_player.play("default")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		_is_paused = !_is_paused	
	
func set_paused(value:bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused

func _on_retomar_button_pressed():
	_is_paused = false

func _on_sair_button_pressed():
	_is_paused = false
	get_tree().change_scene_to_file("res://menus/menu_inicial.tscn")
