extends AnimatedSprite2D
@onready var player : CharacterBody2D = get_node("/root/Game/Player")
var value = 1
func _process(delta: float) -> void:
	scale = Vector2(sqrt(value),sqrt(value))
	var d = (player.global_position - global_position).normalized()
	global_position += d*delta*100*value
	
	if player.global_position.distance_to(global_position)<value:
		player.experience(value)
		queue_free()
