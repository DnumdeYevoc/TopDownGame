extends CharacterBody2D
@export var enemy_type : Resource
@export var speed : int
var d : Vector2
@onready var player: CharacterBody2D = get_parent().get_node("Player")
func _ready() -> void:
	if enemy_type != null:
		enemy_type.speed = speed
	else:
		queue_free()
func _physics_process(delta: float) -> void:
	d=(player.global_position-position-global_position).normalized()
	velocity = d*speed*delta
	move_and_slide()
