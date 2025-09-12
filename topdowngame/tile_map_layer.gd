
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
var tile_array := []
var layer_amount : int

func _ready() -> void:
	for height in layer_amount:
		tile_array.append([])
	update_tiles(chunk_size)
	autotile(tile_array)
	print("start",tile_array,"end")
func update_tiles(size):
		clear()
		for x in size:
			for y in size:
				var pos = Vector2(x,y) 
				#if its not already loaded
				if get_cell_source_id(pos) != 1:
					alt = round(noise.get_noise_2dv(pos+position/32)*100.0)
					if alt > threshold:
						set_cell(pos, 0, Vector2(1,2))
						tile_array[height_index].append(pos+position/32)
		
func autotile(data):
		#data =( all tile positions(position in chunk + chunk global_position), hieght_index)
		for height in data:
			for n in height:
				#if its not being layered over
				#if it exists
					var pos =Vector2(n[0], n[1])
					var cell_id = get_cell_source_id(pos)
					var surrounding : Array[int] = [get_cell_source_id(pos+Vector2(0,1)), 
												get_cell_source_id(pos+Vector2(0,-1)), 
												get_cell_source_id(pos+Vector2(1,0)), 
												get_cell_source_id(pos+Vector2(-1,0))]
					#autotiling
					#if its an edge tile
					if surrounding[0] != cell_id  or surrounding[1] != cell_id or surrounding[2] != cell_id or surrounding[3] != cell_id:
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

func _process(delta: float) -> void:
	var dist = float(render_dis) /2.0
	var player_chunk_pos = parent.player.position / (chunk_size*32)
	var chunk_pos = floor(position / (chunk_size*32))
	var dif = player_chunk_pos - chunk_pos - Vector2(0.5,0.5)
	var moved:=false
	if dif.x > dist:
		position.x += parent.render_dis * chunk_size *32
		moved = true
	elif dif.x < -dist:
		position.x -= parent.render_dis * chunk_size *32
		moved = true
	if dif.y > dist:
		position.y += parent.render_dis * chunk_size *32
		moved = true
	elif dif.y < -dist:
		position.y -= parent.render_dis * chunk_size *32
		moved = true
			
	if moved:
		update_tiles(chunk_size)
		
