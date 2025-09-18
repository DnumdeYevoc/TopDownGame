extends Node2D

const enemy_scene = preload("res://enemy.tscn")
var random := RandomNumberGenerator.new()

@export var enemy_template : Resource

var timer_done := true
var level := -1
var spawn_distance := 1000
@onready var player := get_parent().get_node("Player")
var enemy_type_amount:= 1
var timer_list := []

func _ready() -> void:
	randomize()
	for index in enemy_type_amount:
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 9999999
		timer.autostart = false
		timer.one_shot = true
		timer.timeout.connect(timeout)
		timer_list.append(timer)
	
func _process(delta: float) -> void:
	
	if level == -1:
		spawn(enemy_template, enemy_template.enemy_index)

func spawn(enemy_type, enemy_index) -> void:
	if enemy_type != null:
		if timer_done:
			var max_spawn_amount = enemy_type.max_spawn_amount*10
			for n in max_spawn_amount:
				if random.randi_range(0,enemy_type.spawn_chance) == 1:
					var enemy = enemy_scene.instantiate()
					enemy.enemy_type = enemy_type
					enemy.player = player
					
					var angle = 360/max_spawn_amount *n
					enemy.position =player.position+ Vector2(sin(angle)*spawn_distance, cos(angle)*spawn_distance)
					add_child(enemy)
			
			timer_list[enemy_index].start(enemy_type.spawn_time)
			timer_done = false

func timeout():
	timer_done = true
