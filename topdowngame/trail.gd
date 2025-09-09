extends Line2D

var length : int
var point = Vector2()
var previous_point = Vector2()
var player_speed : int

func _process(delta: float) -> void:
	global_position = Vector2(0,0)
	global_rotation = 0
	player_speed = get_parent().speed
	point = get_parent().global_position
	length = abs(player_speed)**1.5*0.0000003
	width = length/2
	if player_speed<1000:
		default_color = Color8(180,0,120,150)
	elif player_speed>-1000:
		default_color = Color8(210,250,0,150)
		
	if previous_point.distance_to(point)>50:
		add_point(point)
		previous_point = point 
	while get_point_count()> length:
		remove_point(0)
		if get_point_count()==0:
			break
