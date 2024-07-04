extends Node2D

@onready var sprite_drag = $".."
	
func _process(_delta):
	if sprite_drag.flip_h == false:
		position.x = -41.333
	else:
		position.x = 41.333	
