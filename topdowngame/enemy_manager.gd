extends Node2D

const enemy_scene = preload("res://enemy.tscn")
const timer_scene = preload("res://timer.tscn")

var random := RandomNumberGenerator.new()

@export var enemy_type_amount:= 4
@export var enemy_template : Resource
@export var floppy_fish : Resource
@export var shark : Resource
@export var octo : Resource

var timer_done := true
var spawn_distance := 1000
@onready var player := get_parent().get_node("Player")
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
	
	if GLOBALS.level == enemy_template.level_unlock:
		spawn(enemy_template, enemy_template.enemy_index)
	if GLOBALS.level>= floppy_fish.level_unlock:
		spawn(floppy_fish, floppy_fish.enemy_index)
	if GLOBALS.level>= shark.level_unlock:
		spawn(shark, shark.enemy_index)
	if GLOBALS.level>= octo.level_unlock:
		spawn(octo, octo.enemy_index)
	
func spawn(enemy_type, enemy_index) -> void:
	if enemy_type != null:
		if children[enemy_index].timer_done:
			var max_spawn_amount = enemy_type.max_spawn_amount
			var spawn_amount = random.randi_range(enemy_type.min_spawn_amount, enemy_type.max_spawn_amount)
			for n in spawn_amount:
				var angle = deg_to_rad((180/max_spawn_amount *(n+0.5))-90)
				var enemy_position =player.global_position+ Vector2(sin(angle)*spawn_distance, cos(angle)*spawn_distance)
				if enemy_position.y >= enemy_type.min_y:
					var enemy = enemy_scene.instantiate()
					enemy.position = enemy_position
					enemy.enemy_type = enemy_type
					enemy.player = player
					children[enemy_index].add_child(enemy)
			children[enemy_index].start(enemy_type.spawn_time)
			children[enemy_index].timer_done = false
