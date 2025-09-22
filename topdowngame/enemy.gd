extends Area2D
var boids_seen := []
@export var vel := Vector2.UP
@onready var collision: CollisionShape2D = $Collision
@onready var texture: AnimatedSprite2D = $Animation

@onready var experience_scene := preload("res://experience.tscn")
@export var clumping : int 
@export var crowding : int 
@export var speed : int 
@export var enemy_type : Resource
@onready var player: CharacterBody2D

var despawn_range = 10000
var tick_counter :=0
func _ready() -> void:
	randomize()
	add_to_group("enemies")
	if enemy_type != null:
		texture.sprite_frames = enemy_type.sprite_frames
		texture.scale = texture.sprite_frames.get_frame_texture("default",0).get_size()/Vector2(enemy_type.collision_radius*2,enemy_type.collision_radius*2)
		texture.play()
		collision.shape = CircleShape2D.new()
		collision.shape.radius = enemy_type.collision_radius
		speed = enemy_type.speed
		clumping = enemy_type.clumping
		crowding = enemy_type.crowding
	else:
		queue_free()
func _physics_process(delta: float) -> void:
	if player != null:
		if tick_counter == 1:#make this fish layer variable
			vel =(player.global_position-global_position).normalized()
			boids()
			tick_counter = 0

		vel = vel.normalized()*speed*delta*Engine.time_scale
		global_position += vel
		
		if enemy_type.can_rotate:
			rotation = lerp_angle(rotation, atan(vel.y/vel.x), 0.4)
		tick_counter += 1
		
		if player.position.distance_to(position)>despawn_range:
			
			queue_free()

func boids():
	if boids_seen:
		var boid_amount := boids_seen.size()
		var steer_away := Vector2.ZERO
		if boid_amount < 4 or boid_amount > crowding+3:
			for boid in boids_seen:
					steer_away -= ((boid.global_position - global_position)/speed**4)*(1/(((global_position - boid.global_position)/(speed**4)).length_squared()))
					steer_away /= boid_amount
					vel += steer_away

func _on_area_entered(area: Area2D) -> void:
	if area != self and area.is_in_group("enemies"):
		boids_seen.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area and area.is_in_group("enemies"):
		boids_seen.erase(area)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	texture.visible = true
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	texture.visible = false

func die():
	var experience = experience_scene.instantiate()
	experience.position = position
	experience.value = enemy_type.experience_value
	add_sibling(experience)
	queue_free()


func damage_player():
	pass #make sure theres a spawn cooldown
