extends Control

# Nome da animação do bootsplash
@onready var SceneTransitionAnimation = $scene_transition/AnimationPlayer
@onready var animation = $AnimationPlayer

func _ready():
	SceneTransitionAnimation.get_parent().get_node("ColorRect").color.a = 255
	SceneTransitionAnimation.play("fade_out")
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	# Tocar a animação
	animation.play("default")

func _on_animation_finished(anim_name):
	# Verificar se a animação terminada é a que estamos esperando
	if anim_name == "default":
		SceneTransitionAnimation.play("fade_in")
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://bootsplash.tscn")
