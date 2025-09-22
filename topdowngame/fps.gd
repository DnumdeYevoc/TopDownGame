extends Label
func _process(delta: float) -> void:
	text = str(Engine.get_frames_per_second())+", Speed:"+str( get_parent().speed) +", Position:"+str( get_parent().global_position)
