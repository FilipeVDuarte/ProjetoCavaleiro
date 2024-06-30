extends Node2D

@export var quest_amount: int = 1

func _ready():
	$Area2D.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		player.quest_collect(quest_amount)
		queue_free()
