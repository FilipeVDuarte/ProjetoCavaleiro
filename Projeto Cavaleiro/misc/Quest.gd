extends Sprite2D

@export var quest_amount: int = 0

func _ready():
	$Area2D.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		player.objectivequest(quest_amount)
		player.quest_collected.emit(quest_amount)
		queue_free()
