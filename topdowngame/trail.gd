extends Line2D

var length = 10
var point = Vector2()
var previous_point = Vector2()

func _process(delta: float) -> void:
	global_position = Vector2(0,0)
	global_rotation = 0
	point = get_parent().global_position
	length = get_parent().speed*0.0001
	
	if previous_point.distance_to(point)>50:
		add_point(point)
		previous_point = point 
	while get_point_count()> length:
		remove_point(0)
		if get_point_count()==0:
			break
