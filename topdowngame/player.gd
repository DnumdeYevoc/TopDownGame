extends CharacterBody2D
@export var speed : int = 2000
@export var walking_speed := 2000
@export var acc = 500
var speed_cap = 500000
@export var max_health = 100
@onready var trail: Line2D = $Trail
@onready var trail_collision: Area2D = $TrailCollision
@onready var claw_collision: CollisionShape2D = $ClawArea/ClawCollision
@onready var sprite: AnimatedSprite2D = $Sprite2D

@onready var experience_bar: TextureProgressBar = $ExperienceBar
@onready var level_label: Label = $ExperienceBar/LevelLabel
@onready var speed_bar: TextureProgressBar = $SpeedBar
@onready var speed_label: Label = $SpeedBar/SpeedLabel
@onready var health_bar: TextureProgressBar = $HealthBar

@onready var negative_speed_texture = preload("res://ProgessBarTextures/NegativeSpeed.png")
@onready var speed_texure = preload("res://ProgessBarTextures/Speed.png")
var decelerate := false
var d = Vector2(0,0)
var experience_value := 0
var dead := false

func _ready() -> void:
	speed_cap = 101000
	speed_bar.max_value = speed_cap
	@warning_ignore("integer_division")
	speed_bar.size.x = speed_cap/1000
	health_bar.max_value = max_health
	update_health_bar()
func _input(event: InputEvent) -> void:
	#slowdown time
	if speed != 0:
		if Engine.time_scale > sqrt(walking_speed*2.5/abs(speed)):
			if Input.is_action_pressed("Shift"):
				Engine.time_scale -= 0.03
		if Input.is_action_just_released("Shift"):
			Engine.time_scale = 1
		
func _physics_process(delta: float) -> void:
	#movement
	d=(get_global_mouse_position()-global_position).normalized()

	#deceleration
	if Input.is_action_just_pressed("Right_Click"):
		if speed<= walking_speed and speed>=0:
			speed = -walking_speed
	if Input.is_action_pressed("Right_Click") or decelerate == true:
			if speed> walking_speed:
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
				
	#attack
	if Input.is_action_just_pressed("c"):
		sprite.play("Claw")
		claw_collision.disabled = false
	if Input.is_action_just_released("c"):
		sprite.play("DownSlow")
		claw_collision.disabled = true
		
	#speedbar
	if speed< -1000:
		speed_bar.texture_progress = negative_speed_texture
		speed_bar.max_value = speed_cap*2
		speed_bar.tooltip_text = "Max Speed: ???"
		speed_bar.size.x = speed_cap/250
	elif speed>1000:
		speed_bar.texture_progress = speed_texure
		speed_bar.max_value = speed_cap
		speed_bar.tooltip_text = "Max Speed: "+str(speed_cap)
		speed_bar.size.x = speed_cap/500
	speed_bar.value = abs(speed)
	speed_label.text = str(speed/1500) + "km/h"
	#update pos
	velocity = d*delta*speed
	move_and_slide()
	
	#animation 
	var atlas := Vector2(0,0)
	if d.y>0.5:
		atlas.y += 1
	elif d.y<-0.5:
		atlas.y-= 1
	if d.x>0.5:
		atlas.x += 1
	elif d.x <-0.5:
		atlas.x-= 1
	if not sprite.animation == "Claw":
		if atlas == Vector2(1,0):
			sprite.play("RightSlow")
		if atlas == Vector2(-1,0):
			sprite.play("LeftSlow")
		if atlas == Vector2(0,1):
			sprite.play("DownSlow")
		if atlas == Vector2(0,-1):
			sprite.play("UpSlow")
		
	sprite.speed_scale = clamp(sqrt(abs(speed))/100, 0.5, 10)

func experience(value):
	experience_value += value
	experience_bar.value += experience_value
	if experience_bar.value >= experience_bar.max_value:
		level_up()
func level_up():
		GLOBALS.level += 1
		level_label.text = "Level " + str(GLOBALS.level)
		experience_bar.value -= experience_bar.max_value
		experience_bar.max_value += 100
		#Upgrades
		speed_cap += 5000*GLOBALS.level
		take_damage(10)

		speed_bar.size.x = speed_cap/1000
func _on_trail_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.die()
		




func take_damage(damage):
	health_bar.value -=damage
	update_health_bar()
	if health_bar.value <=0:
		die()
	
func heal(amount):
	health_bar.value += amount
	update_health_bar()
	
func update_health_bar():
	health_bar.max_value = max_health
	if health_bar.value == health_bar.max_value:
		health_bar.visible = false
	else:
		health_bar.visible =true

func die():
	dead = true
	queue_free()
	get_tree().change_scene_to_file("res://title_screen.tscn")


func _on_claw_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.die()
