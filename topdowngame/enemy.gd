extends Area2D


var boids_seen := []
@export var vel := Vector2.UP
var movv := 4000

@onready var collision: CollisionShape2D = $Collision
@onready var texture: Sprite2D = $Sprite2D

@export var speed : int 
@export var enemy_type : Resource

@onready var player: CharacterBody2D
var despawn_range = 10000
var tick_counter :=0
func _ready() -> void:
	randomize()
	add_to_group("enemies")
	if enemy_type != null:
		speed = enemy_type.speed
	else:
		queue_free()
func _physics_process(delta: float) -> void:
	if player != null:
		if tick_counter == 1:#make this fish layer variable
			vel =(player.global_position-global_position).normalized()
			boids()
			tick_counter = 0

		vel = vel.normalized()*speed*delta
		
		global_position += vel
		if enemy_type.can_rotate:
			rotation = lerp_angle(rotation, atan(vel.y/vel.x), 0.4)
			
		tick_counter += 1
		
		if player.position.distance_to(position)>despawn_range:
			queue_free()

				
func boids():
	if boids_seen:
		var boid_amount := boids_seen.size()
		var avg_vel := Vector2.ZERO
		var steer_away := Vector2.ZERO
		
		for boid in boids_seen:
			avg_vel += boid.vel
			avg_vel/= boid_amount
			vel += (avg_vel-vel)/6
			steer_away -= (boid.global_position - global_position)* (movv/(global_position - boid.global_position).length())
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
