
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
var tileset_id :int = 0
var layer_amount : int
var threshold_rate : int
var water_level :int = 3
func _ready() -> void:
	if height_index<water_level:
		modulate *= (float(height_index)+1.0)/20.0
		tileset_id = 2
	elif height_index == water_level:
		tileset_id = 1
	else:
		tileset_id = 0
		modulate *= (float(height_index)+15.0)/20.0
	update_tiles(chunk_size)

func _physics_process(delta: float) -> void:
	'''if height_index == water_level+1:
		if get_cell_source_id((player.position / 32 )- (floor(position / 32))) == 0:
			print('trigger')
		elif get_cell_source_id((player.position / 32 )- (floor(position / 32))) == 2:
			print('trigger')'''
	#figure out how tf to tell if hes on water or not
func update_tiles(size):
		clear()
		for x in size:
			for y in size:
				var pos = Vector2(x,y) 
				var atlas : Vector2
				#if its not already loaded
				if get_cell_source_id(pos) != 1:
						alt = round(noise.get_noise_2dv(pos+position/32)*100.0)
						if alt > threshold + floor((global_position.y/32+y)*0.01):
							if get_cell_atlas_coords(pos) != Vector2i(1,2):
								#autotiling
								var surrounding : Array[int] = [(round(noise.get_noise_2dv(pos+Vector2(0,1)+position/32)*100.0)), 
															(round(noise.get_noise_2dv(pos+Vector2(0,-1)+position/32)*100.0)), 
															(round(noise.get_noise_2dv(pos+Vector2(1,0)+position/32)*100.0)), 
															(round(noise.get_noise_2dv(pos+Vector2(-1,0)+position/32)*100.0))]
								atlas = Vector2(2,1)
								if surrounding[0]>threshold+ floor((global_position.y/32+y+1)*0.01):
									atlas.y += 2
								if surrounding[1]>threshold + floor((global_position.y/32+y-1)*0.01):
									atlas.y += -1
								if surrounding[2]>threshold + floor((global_position.y/32+y)*0.01):
									atlas.x += 1
								if surrounding[3]>threshold + floor((global_position.y/32+y)*0.01):
									atlas.x += -2
							else:
								atlas = get_cell_atlas_coords(pos)
							set_cell(pos, tileset_id, atlas)
			#shader stuff

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
