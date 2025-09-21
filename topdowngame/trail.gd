extends Line2D
@onready var trail_collision: Area2D = $"../TrailCollision"
var random  := RandomNumberGenerator.new()
var length : int
var point = Vector2()
var previous_point = Vector2()
var player_speed : int
var counter =0
@onready var player = get_parent()
var update = true
func _process(delta: float) -> void:
	global_position = Vector2(0,0)
	global_rotation = 0
	player_speed = player.speed
	point = player.global_position
	
	if Input.is_action_just_pressed("Space"):
		if update:
			attack()

	if update:
		length = abs(player_speed)**1.5*0.0000003
		width = length/2
	
		if player_speed<1000:
			default_color = Color8(180,0,120,150)
		elif player_speed>-1000:
			default_color = Color8(210,250,0,150)
		
		if Engine.time_scale< 0.3:
			length *= 5
			if previous_point.distance_to(point)>10:
				add_point(point)
				previous_point = point 
		if previous_point.distance_to(point)>50:
			point.x += random.randi_range(-10, 10)
			point.y += random.randi_range(-10, 10)
			add_point(point)
			previous_point = point 
		while get_point_count()> length:
			remove_point(0)
			if get_point_count()==0:
				break

	
func attack():
	width *=15
	update = false
	player.decelerate = true
	for p in get_point_count()-1:
			var p1 = points[p]
			var p2 = points[p+1]
			var center = (p1 + p2) / 2.0
			var length = p1.distance_to(p2)
			var angle = (p2 - p1).angle()
			var rect_shape = RectangleShape2D.new()
			
			rect_shape.size = Vector2(length , width)
			var collision_shape_node = CollisionShape2D.new()
			collision_shape_node.shape = rect_shape
			collision_shape_node.position = center-get_parent().position
			collision_shape_node.rotation = angle
			trail_collision.add_child(collision_shape_node)
	var timer = get_tree().create_timer(0.1)
	await timer.timeout
	for c in trail_collision.get_children():
		trail_collision.remove_child(c)
	update =true
	clear_points()
	var timer2 = get_tree().create_timer(0.5)
	await timer2.timeout
	player.decelerate = false
