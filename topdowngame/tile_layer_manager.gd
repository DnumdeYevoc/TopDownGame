
extends Node2D
const chunk_scene = preload("res://tile_map_layer.tscn")
var random = RandomNumberGenerator.new()

@onready var layer_amount = 5
@export var threshold_rate := 20
var render_dis := 4.0
@export var noise = FastNoiseLite.new()
@export var world_seed := 0
@export var chunk_size := 10

@onready var player =$"../Player"
@onready var first := true
var tile_array := []
var chunk_array := []

func _ready() -> void:
	world_seed=  random.randi_range(0,99999999)
	noise.seed = world_seed
	noise.frequency = 0.01
	noise.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	noise.fractal_weighted_strength = 1
	generate_start_chunks()
	
func generate_start_chunks() -> void:
	var index = 0
	for x in range(render_dis):
		for y in range(render_dis):
			index += 1
			for height in layer_amount:
				tile_array.append([])
				chunk_array.append([])
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
		instance.tile_array = tile_array
		instance.chunk_array = chunk_array
		instance.threshold = threshold_rate*layer
		var x = (pos.x-render_dis/2.0)*chunk_size*32
		var y = (pos.y-render_dis/2.0)*chunk_size*32
		instance.global_position = Vector2(x,y)
		add_child(instance)
		
func autotile(tile_list, chunk_list):
		#data =[[tile positions at eght 0],[tile positions at height 1], etc.)
		
		var height_index = 0
		
		for height in tile_list:
			var tile_index =0
			for n in height:
					
				#if its not being layered over
				#if it exists
					var pos =n

					
					var surrounding : Array[Vector2] = [(pos+Vector2(0,1)), 
												(pos+Vector2(0,-1)), 
												(pos+Vector2(1,0)), 
												(pos+Vector2(-1,0))]
					#autotiling
					#if its an edge tile
					var atlas = Vector2(2,1)
					if tile_list[height_index].has(surrounding[0]):
						atlas.y += 2
					if tile_list[height_index].has(surrounding[1]):
						atlas.y += -1
					if tile_list[height_index].has(surrounding[2]):
						atlas.x += 1
					if tile_list[height_index].has(surrounding[3]):
						atlas.x += -2
					
					chunk_list[height_index][tile_index].set_cell(pos- chunk_list[height_index][tile_index].position/32, 0, atlas)
					tile_index +=1
					first = false
			height_index +=1
