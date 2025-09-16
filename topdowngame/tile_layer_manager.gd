
extends Node2D
const chunk_scene = preload("res://tile_map_layer.tscn")
var random = RandomNumberGenerator.new()

@onready var layer_amount = 7
@export var threshold_rate := 4
var render_dis := 6.0
@export var noise = FastNoiseLite.new()
@export var world_seed := 0
@export var chunk_size := 10
@onready var player =$"../Player"
@onready var first := true

func _ready() -> void:
	world_seed=  random.randi_range(0,99999999)
	noise.seed = world_seed
	noise.frequency = 0.005
	noise.domain_warp_amplitude = 1
	noise.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	noise.fractal_weighted_strength = 3
	generate_start_chunks()

func generate_start_chunks() -> void:
	var index = 0
	for x in range(render_dis):
		for y in range(render_dis):
			create_chunk(Vector2(x,y))

func create_chunk(pos : Vector2) -> void:
	for layer in layer_amount:
		var instance = chunk_scene.instantiate()
		instance.player = player
		instance.noise = noise
		instance.render_dis = render_dis
		instance.chunk_size = chunk_size
		instance.height_index  = layer
		instance.layer_amount = layer_amount
		instance.threshold_rate = threshold_rate
		instance.threshold = (threshold_rate*layer)**1.3-40
		var x = (pos.x-render_dis/2.0)*chunk_size*32
		var y = (pos.y-render_dis/2.0)*chunk_size*32
		instance.global_position = Vector2(x,y)
		add_child(instance)
