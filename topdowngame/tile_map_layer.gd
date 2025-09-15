
extends TileMapLayer
var random = RandomNumberGenerator.new()

@onready var player : CharacterBody2D
@export var noise : FastNoiseLite
@export var threshold :int
@export var height_index :int
@export var render_dis = 4.0
@onready var parent = get_parent()
var chunk_size := 10.0
var alt : float
var tile_array : Array
var chunk_array : Array
var chunk_index : int

var layer_amount : int

func _ready() -> void:
	update_tiles(chunk_size, tile_array)
	parent.autotile(tile_array, chunk_array)

func update_tiles(size, tile_array):
		clear()
		for x in size:
			for y in size:
				var pos = Vector2(x,y) 
				#if its not already loaded
				if get_cell_source_id(pos) != 1:
					alt = round(noise.get_noise_2dv(pos+position/32)*100.0)
					if alt > threshold:
						set_cell(pos, 0, Vector2(1,2))
						tile_array[height_index].append(Vector2(pos+position/32))#fix
						chunk_array[height_index].append(self)

func _process(delta: float) -> void:
	var dist = float(render_dis) /2.0
	var player_chunk_pos = parent.player.position / (chunk_size*32)
	var chunk_pos = floor(position / (chunk_size*32))
	var dif = player_chunk_pos - chunk_pos - Vector2(0.5,0.5)
	var moved:=false
	if dif.x > dist:
		clear_from_array()
		position.x += parent.render_dis * chunk_size *32
		moved = true
	elif dif.x < -dist:
		clear_from_array()
		position.x -= parent.render_dis * chunk_size *32
		moved = true
	if dif.y > dist:
		clear_from_array()
		position.y += parent.render_dis * chunk_size *32
		moved = true
	elif dif.y < -dist:
		clear_from_array()
		position.y -= parent.render_dis * chunk_size *32
		moved = true
	if moved:
		update_tiles(chunk_size, tile_array)
		parent.autotile(tile_array, chunk_array)

func clear_from_array():
	var index =0
	for chunk in chunk_array[height_index]:
		if chunk == self:
			tile_array[height_index].remove_at(index)
			chunk_array[height_index].remove_at(index)
			index-=1
		index+=1
