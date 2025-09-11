
extends Node2D
const chunk_scene = preload("res://world_layer.tscn")
var random = RandomNumberGenerator.new()

@onready var amount = 5
@export var threshold_rate := 20
@export var render_dis = 3
@export var noise = FastNoiseLite.new()
@export var world_seed := 0
@export var chunk_size := 10
@onready var player =$"../Player"
var index = 0

func _ready() -> void:
	noise.seed = world_seed
	noise.frequency = 0.01
	noise.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	noise.fractal_weighted_strength = 1
	generate_start_chunks()
	
func generate_start_chunks() -> void:
	for x in range(render_dis):
		for y in range(render_dis):
			create_chunk(Vector2(x,y))
			
func create_chunk(pos : Vector2i) -> void:
	index = 0
	for layer in amount:
		var instance = chunk_scene.instantiate()
		instance.player = player
		instance.noise = noise
		instance.render_dis = render_dis
		instance.chunk_size = chunk_size
		instance.threshold = threshold_rate*index
		var x = (pos.x-render_dis/2.0)*chunk_size
		var y = (pos.y-render_dis/2.0)*chunk_size
		instance.global_position = Vector2(x,y)
		add_child(instance)
		index += 1

		
