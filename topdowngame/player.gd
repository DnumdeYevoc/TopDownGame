extends CharacterBody2D
@export var speed = 2500
@export var acc = 1000
var speed_cap = 200000
var decel := false
@onready var trail: Line2D = $Trail
var d = Vector2(0,0)
func _physics_process(delta: float) -> void:
	#movement
	d=(get_global_mouse_position()-global_position).normalized()
	#acceleration
	if Input.is_action_pressed("Left_Click"):
		if speed < speed_cap:
			speed +=acc
		#deceleration
	elif Input.is_action_pressed("Right_Click"):
		decel = true
	else:
		decel = false
	if decel:
		speed -= acc*2
		if speed<= 2500:
			decel = false
	#slow down time
	if Input.is_action_pressed("Shift"):
		pass
	
	#trail
	if d== Vector2(0,0):
		decel = false
		if trail.get_point_count()>0:
			trail.remove_point(0)
	
	#update speed
	velocity = d*delta*speed
	move_and_slide()
