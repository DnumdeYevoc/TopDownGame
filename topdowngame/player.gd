extends CharacterBody2D
@export var speed : int
@export var walking_speed := 5000.00
@export var acc = 500
var speed_cap = 200000
@onready var trail: Line2D = $Trail
var d = Vector2(0,0)
func _input(event: InputEvent) -> void:
	#slowdown time
	if speed != 0:
		if Engine.time_scale > sqrt(walking_speed/abs(speed)):
			if Input.is_action_pressed("Shift"):
				Engine.time_scale -= 0.03
			Engine.time_scale = 1
		
func _physics_process(delta: float) -> void:
	#movement
	d=(get_global_mouse_position()-global_position).normalized()
	#acceleration
	if Input.is_action_just_pressed("Left_Click"):
		if speed>= -walking_speed and speed<=0:
			speed = walking_speed
	if Input.is_action_pressed("Left_Click"):
		if speed < speed_cap:
			if speed< -walking_speed or  speed>0:
				speed +=acc*Engine.time_scale
			else:
				speed = 0
	#deceleration
	elif Input.is_action_pressed("Right_Click"):
		if speed>-2*speed_cap:
			if speed> walking_speed or  speed<0:
				speed -=3*acc*Engine.time_scale
			else:
				speed = walking_speed
	if Input.is_action_just_pressed("Right_Click"):
		if speed<= walking_speed and speed>=0:
			speed = -walking_speed

	#update speed
	velocity = d*delta*speed
	move_and_slide()
