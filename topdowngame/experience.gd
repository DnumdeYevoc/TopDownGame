extends Sprite2D
@onready var player : CharacterBody2D = get_node("/root/Game/Player")
var value = 1

func _process(delta: float) -> void:
	var n = clamp(sqrt((value/20000)),1,100)
	scale = Vector2(n,n)

	var d = (player.global_position - global_position).normalized()
	global_position += d*delta*Engine.time_scale*abs(player.global_position - global_position)*(player.speed/1000)
	
	if player.global_position.distance_to(global_position)<20:
		player.experience(value)
		queue_free()
