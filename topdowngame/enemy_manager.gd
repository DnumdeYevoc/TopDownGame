extends Node2D
const enemy_scene = preload("res://enemy.tscn")
@export var enemy_template : Resource
var timer = Timer.new()
var level := -1
func _ready() -> void:
	timer.autostart = true
	timer.connect("timeout",timeout)
	pass
func _process(delta: float) -> void:
	if level == -1 :
		spawn(enemy_template)

func spawn(enemy_type) -> void:
	if enemy_type != null:
		var spawn_time = enemy_type.spawn_time
		timer.wait_time = spawn_time
		if timeout():
			print('spawn')

func timeout():
	print('timeout')
	return true

#need to fix
