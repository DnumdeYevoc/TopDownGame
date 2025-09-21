extends Node2D

const enemy_scene = preload("res://enemy.tscn")
const timer_scene = preload("res://timer.tscn")

var random := RandomNumberGenerator.new()

@export var enemy_template : Resource
@export var floppy_fish : Resource

var timer_done := true
var level := -1
var spawn_distance := 1000
@onready var player := get_parent().get_node("Player")
var enemy_type_amount:= 2

var children := []
func _ready() -> void:
	randomize()
	for index in enemy_type_amount:
		var timer := timer_scene.instantiate()
		add_child(timer)
	children= get_children()
func _process(delta: float) -> void:
	spawn_distance = sqrt(sqrt(player.speed)*300)
	if spawn_distance< 1000:
		spawn_distance = 1000

	if level == -1:
		spawn(enemy_template, enemy_template.enemy_index)
		spawn(floppy_fish, floppy_fish.enemy_index)

func spawn(enemy_type, enemy_index) -> void:
	if enemy_type != null:
		if children[enemy_index].timer_done:
			var max_spawn_amount = enemy_type.max_spawn_amount
			for n in max_spawn_amount:
				if random.randi_range(1,enemy_type.spawn_chance) == 1:
					var enemy = enemy_scene.instantiate()
					enemy.enemy_type = enemy_type
					enemy.player = player
					var angle = deg_to_rad((180/max_spawn_amount *(n+0.5))-90)
					enemy.position =player.position+ Vector2(sin(angle)*spawn_distance, cos(angle)*spawn_distance)
					children[enemy_index].add_child(enemy)
			children[enemy_index].start(enemy_type.spawn_time)
			children[enemy_index].timer_done = false
