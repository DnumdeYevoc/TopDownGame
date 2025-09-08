extends CharacterBody2D
@export var speed = 50000
@export var acc = 500
var speed_cap = 200000
@export var trail_length : int
@onready var trail: Line2D = $Trail
var d = Vector2(0,0)
func _physics_process(delta: float) -> void:
	trail.length = trail_length
	#basic movement

	'''
	if Input.is_action_pressed("Forward"):
		d.y -= 1
	if Input.is_action_pressed("Backward"):
		d.y += 1
	if Input.is_action_pressed("Right"):
		d.x += 1
	if Input.is_action_pressed("Left"):
		d.x -= 1'''
	#get_global_mouse_position()
	if Input.is_action_pressed("Left_Click"):
		d=(get_global_mouse_position()-global_position).normalized()
		if speed < speed_cap:
			speed +=acc
	else:
		speed = 50000
		d = Vector2(0,0)
	if d<= Vector2(0.01,0.01)and d>= Vector2(-0.01,-0.01):
		trail.remove_point(0)
	velocity = d*delta*speed
	move_and_slide()
