@tool
extends Node2D
const world_layer_scene = preload("res://world_layer.tscn")
var random = RandomNumberGenerator.new()

@onready var amount = 5
@export var threshold_rate := 20
@export var render_dis = Vector2i(100, 75)
@export var noise = FastNoiseLite.new()
@export var world_seed := 0
@export var refresh_dis = 10
@onready var player =$"../Player"
var index = 0

@export var randomise_seed :bool = false:
	set(new):
		randomise_seed = new
		world_seed = random.randi_range(0,99999999)
		noise.seed = world_seed
		randomise_seed = false
@export var reload :bool = false:
	set(new):
		reload = new
		generate_world()
		reload = false

func _ready() -> void:
	noise.seed = world_seed
	noise.frequency = 0.01
	noise.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	noise.fractal_weighted_strength = 1
	generate_world()
func generate_world():
	index = 0
	for layer in amount:
		add_child(world_layer_scene.instantiate())
	for child in get_children():
		child.noise = noise
		child.player = player
		child.refresh_dis = refresh_dis
		child.ref_point = player.position
		child.render_dis = render_dis
		child.player = player
		child.threshold = threshold_rate*index
		child.generate_tiles(render_dis)
		index += 1
