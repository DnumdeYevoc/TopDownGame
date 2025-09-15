
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

var layer_amount : int

func _ready() -> void:
	update_tiles(chunk_size)
	
func _physics_process(delta: float) -> void:
	'''var current_rel_tile = parent.player.position / (chunk_size) -floor(position / (chunk_size))
	print(current_rel_tile)
	if current_rel_tile <= Vector2(32,32):
		if get_cell_atlas_coords(current_rel_tile).x<= 1:
			pass
			parent.player.position.y -= 10'''
	
func update_tiles(size):
		clear()
		for x in size:
			for y in size:
				var pos = Vector2(x,y) 
				var atlas : Vector2
				#if its not already loaded
				if get_cell_source_id(pos) != 1:
					alt = round(noise.get_noise_2dv(pos+position/32)*100.0)
					if alt > threshold:
						if get_cell_atlas_coords(pos) != Vector2i(1,2):
							#autotiling
							var surrounding : Array[int] = [(round(noise.get_noise_2dv(pos+Vector2(0,1)+position/32)*100.0)), 
														(round(noise.get_noise_2dv(pos+Vector2(0,-1)+position/32)*100.0)), 
														(round(noise.get_noise_2dv(pos+Vector2(1,0)+position/32)*100.0)), 
														(round(noise.get_noise_2dv(pos+Vector2(-1,0)+position/32)*100.0))]
							atlas = Vector2(2,1)
							if surrounding[0]>threshold:
								atlas.y += 2
							if surrounding[1]>threshold:
								atlas.y += -1
							if surrounding[2]>threshold:
								atlas.x += 1
							if surrounding[3]>threshold:
								atlas.x += -2
						else:
							atlas = get_cell_atlas_coords(pos)
						set_cell(pos, 0, atlas)
			if height_index ==0:
				collision_enabled = true
			else:
				collision_enabled = false
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
