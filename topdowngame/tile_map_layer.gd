@tool

extends TileMapLayer
var random = RandomNumberGenerator.new()

@onready var player : CharacterBody2D
@export var noise : FastNoiseLite
@export var threshold :int
@export var render_dis : int
@onready var parent = get_parent()
var chunk_size = 32
var generating := false
var alt : float
@export var randomise_seed :bool = false:
	set(new):
		randomise_seed = new
		noise.seed=  random.randi_range(0,99999999)
		randomise_seed = false
@export var reload :bool = false:
	set(new):
		reload = new
		update_tiles(chunk_size)
		reload = false

func _ready() -> void:
	update_tiles(chunk_size)

func update_tiles(size):
		generating = true
		clear()
		for x in size:
			for y in size:
				var pos = Vector2(x,y)+ position
				#if its not already loaded
				if get_cell_source_id(pos) != 1:
					alt = round(noise.get_noise_2dv(pos)*100.0)
					if alt > threshold:
						set_cell(pos, 0, Vector2(1,2))
		for x in size:
			for y in size:
				#if its not being layered over
				#if it exists
					var pos = Vector2(x,y)+ position
					var cell_id = get_cell_source_id(pos)
					var surrounding : Array[int] = [get_cell_source_id(pos+Vector2(0,1)), 
												get_cell_source_id(pos+Vector2(0,-1)), 
												get_cell_source_id(pos+Vector2(1,0)), 
												get_cell_source_id(pos+Vector2(-1,0))]
					#autotiling
					#if its an edge tile
					if surrounding[0] != cell_id or surrounding[1] != cell_id or surrounding[2] != cell_id or surrounding[3] != cell_id:
						var atlas = Vector2(2,1)
						if surrounding[0] == cell_id:
							atlas.y += 2
						if surrounding[1] == cell_id:
							atlas.y += -1
						if surrounding[2] == cell_id:
							atlas.x += 1
						if surrounding[3] == cell_id:
							atlas.x += -2
						set_cell(pos, cell_id, atlas)
		generating = false
			
func _process(delta: float) -> void:
	if generating:
		return
	var dist = float(parent.render_dis) / 2.0
	var player_chunk_pos = parent.player.position / (chunk_size*32)
	var chunk_pos = floor(position / (chunk_size*32))
	var dif = player_chunk_pos - chunk_pos - Vector2(0.5,0.5)
	var moved := false
	if dif.x > dist:
		position.x += parent.render_dis * chunk_size*32
		moved = true
	elif dif.x < -dist:
		position.x -= parent.render_dis * chunk_size*32
		moved = true
	if dif.y > dist:
		position.y += parent.render_dis * chunk_size*32
		moved = true
	elif dif.y < -dist:
		position.y -= parent.render_dis * chunk_size*32
		moved = true
		
	if moved:
		update_tiles(chunk_size)
