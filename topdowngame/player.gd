extends CharacterBody2D
@export var speed : int
@export var walking_speed := 5000.00
@export var acc = 500
var speed_cap = 500000
@onready var trail: Line2D = $Trail
@onready var trail_collision: Area2D = $TrailCollision
@onready var sprite: AnimatedSprite2D = $Sprite2D

var decelerate := false
var d = Vector2(0,0)
func _input(event: InputEvent) -> void:
	#slowdown time
	if speed != 0:
		if Engine.time_scale > sqrt(walking_speed/abs(speed)):
			if Input.is_action_pressed("Shift"):
				Engine.time_scale -= 0.03
		if Input.is_action_just_released("Shift"):
			Engine.time_scale = 1
		
func _physics_process(delta: float) -> void:
	#movement
	d=(get_global_mouse_position()-global_position).normalized()
	#animation 
	var atlas := Vector2(0,0)
	if d.y>0:
		atlas.y += 1
	elif d.y<0:
		atlas.y-= 1
	#make this work
	
	#deceleration
	if Input.is_action_just_pressed("Right_Click"):
		if speed<= walking_speed and speed>=0:
			speed = -walking_speed
	if Input.is_action_pressed("Right_Click") or decelerate == true:
		if speed>-2*speed_cap:
			if speed> walking_speed or  speed<0:
				if decelerate:
					speed -=6*acc*Engine.time_scale
				else:
					speed -=3*acc*Engine.time_scale
			else:
				speed = walking_speed
	#acceleration
	elif Input.is_action_just_pressed("Left_Click"):
		if speed>= -walking_speed and speed<=0:
			speed = walking_speed
	elif Input.is_action_pressed("Left_Click"):
		if speed < speed_cap:
			if speed< -walking_speed or  speed>0:
				speed +=acc*Engine.time_scale
			else:
				speed = 0
	
	#update speed
	velocity = d*delta*speed
	move_and_slide()


func _on_trail_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.die()
	
