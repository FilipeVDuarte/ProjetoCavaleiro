extends Control

# Nome da animação do bootsplash
@onready var animation = $AnimationPlayer

func _ready():
	# Conectar o sinal de término da animação
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	# Tocar a animação
	animation.play("default")

func _on_animation_finished(anim_name):
	# Verificar se a animação terminada é a que estamos esperando
	if anim_name == "default":
		# Carregar a próxima cena
		get_tree().change_scene_to_file("res://menus/menu_inicial.tscn")
