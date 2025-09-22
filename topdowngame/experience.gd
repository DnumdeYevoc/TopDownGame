extends AnimatedSprite2D
@onready var player : CharacterBody2D = get_node("/root/Game/Player")
var value = 1
func _process(delta: float) -> void:
	var n = clamp(sqrt((value/20000)),0.5,100)
	scale = Vector2(n,n)

	var d = (player.global_position - global_position).normalized()
	global_position += d*delta*1000*(1.0/value)*Engine.time_scale*abs(player.global_position - global_position)
	
	if player.global_position.distance_to(global_position)<value*3:
		player.experience(value)
		queue_free()
