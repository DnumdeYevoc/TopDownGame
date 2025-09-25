extends CharacterBody2D
@export var speed : int = 2000
@export var walking_speed := 2000
@export var acc = 500
@export var healing = 0.1
var speed_cap = 500000
@export var max_health = 100
@onready var trail: Line2D = $Trail
@onready var trail_collision: Area2D = $TrailCollision
@onready var claw_collision: CollisionShape2D = $ClawArea/ClawCollision
@onready var self_collision: CollisionShape2D = $SelfCollision
@onready var sprite: AnimatedSprite2D = $Sprite2D

@onready var experience_bar: TextureProgressBar = $ExperienceBar
@onready var level_label: Label = $ExperienceBar/LevelLabel
@onready var speed_bar: TextureProgressBar = $SpeedBar
@onready var speed_label: Label = $SpeedBar/SpeedLabel
@onready var health_bar: TextureProgressBar = $HealthBar

@onready var negative_speed_texture = preload("res://ProgessBarTextures/NegativeSpeed.png")
@onready var speed_texure = preload("res://ProgessBarTextures/Speed.png")

var level_up_animation := false
var decelerate := false
@export var negative := false
var d = Vector2(0,0)

var dead := false
var attack_cooldown_amount = 48 #8 minimum
var cooldown :int
var trail_damage_factor :=1
var claw_damage := 10

var counter := 0
func _ready() -> void:
	
	speed_cap = 6000
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

	#healing 
	health_bar.value += delta*healing
	#movement
	d=(get_global_mouse_position()-global_position).normalized()
	#deceleration
	if Input.is_action_just_pressed("Right_Click"):
		if speed<= walking_speed and speed>=0:
			speed = -walking_speed
	if Input.is_action_pressed("Right_Click") or decelerate == true:
		if negative:
			if speed: #turn lf for negative
				if decelerate:
					speed -=6*acc*Engine.time_scale
				else:
					speed -=3*acc*Engine.time_scale
			else:
				speed = walking_speed
		else:
			if speed> walking_speed: #turn lf for negative
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
	if Input.is_action_just_pressed("c") and cooldown== 0:
		sprite.play("Claw")
		claw_collision.disabled = false
		self_collision.disabled = true
		cooldown = attack_cooldown_amount
		
	if sprite.frame == 6 and cooldown<= attack_cooldown_amount-8 :
		sprite.play("DownSlow")
		claw_collision.disabled = true
		self_collision.disabled =false
	if cooldown>=1:
		cooldown-=1
	#speedbar
	if speed< -1000:
		speed_bar.texture_progress = negative_speed_texture
		speed_bar.max_value = speed_cap*2
		speed_bar.tooltip_text = "Max Speed: ???"
		
	elif speed>1000:
		speed_bar.texture_progress = speed_texure
		speed_bar.max_value = speed_cap
		speed_bar.tooltip_text = "Max Speed: "+str(speed_cap/1500)
	
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
	#makeshift level up animation

	if level_up_animation:
		counter +=1
		var font_size=level_label.get_theme_font_size("font_size")
		if counter<=25:
			level_label.add_theme_font_size_override("font_size", font_size+(counter)/5)
		else:
			if counter <50:
				level_label.add_theme_font_size_override("font_size", font_size-((counter-25)/5))
			else:
				#reset
				level_label.add_theme_font_size_override("font_size", 25)
				level_up_animation = false
				counter = 0
				update_health_bar()
				
func experience(value):
	
	experience_bar.value += value
	if experience_bar.value >= experience_bar.max_value:
		level_up()
		
func level_up():
		level_up_animation = true
		GLOBALS.level += 1
		level_label.text = "Level " + str(GLOBALS.level)
		
		experience_bar.value -= experience_bar.max_value
		experience_bar.max_value += 25*GLOBALS.level

			
		#Upgrades
		speed_cap += 5000*GLOBALS.level
		speed_bar.size.x = speed_cap/1000
		claw_collision.shape.radius +=0.005*GLOBALS.level
		if attack_cooldown_amount !=8:
			attack_cooldown_amount -= 1
		claw_damage += 1
		trail_damage_factor+=0.05
		health_bar.max_value += 10
		heal(10)
		healing += 0.05
		update_health_bar()
		health_bar.visible =true

		#check for another level up
		if experience_bar.value >= experience_bar.max_value:
			level_up()
		

func _on_trail_collision_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.take_damage(trail.length*trail_damage_factor)

func take_damage(damage):
	health_bar.value -=damage
	update_health_bar()
	if health_bar.value <=0:
		die()
	
func heal(amount):
	health_bar.value += amount
	update_health_bar()
	
func update_health_bar():
	health_bar.size.x = health_bar.max_value
	health_bar.position.x = -(health_bar.max_value)/4 
	if health_bar.value == health_bar.max_value:
		health_bar.visible = false
	else:
		health_bar.visible =true

func die():
	dead = true
	queue_free()
	get_tree().reload_current_scene()


func _on_claw_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.take_damage(claw_damage)
