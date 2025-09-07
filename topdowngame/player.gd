extends CharacterBody2D
@export var speed = 10000

func _physics_process(delta: float) -> void:
	#basic movement
	var d = Vector2(0,0)
	if Input.is_action_pressed("Forward"):
		d.y -= 1
	if Input.is_action_pressed("Backward"):
		d.y += 1
	if Input.is_action_pressed("Right"):
		d.x += 1
	if Input.is_action_pressed("Left"):
		d.x -= 1
		
	d = d.normalized()
	velocity = d*delta*speed
	move_and_slide()
