@tool
extends TileMapLayer
@export var reload :bool = false:
	set(new):
		reload = new
		generate_buildings()
		reload = false
@export var world_seed := 0:
	set(new_seed):
		world_seed = new_seed
		generate_buildings()
		
@export var noise : FastNoiseLite
@export var load_range = Vector2(100, 100):
	set(new_range):
		load_range = new_range
		generate_buildings()
		
var alt : float
func _ready() -> void:
	generate_buildings()

func generate_buildings():
	clear()
	noise.seed = world_seed
	for x in load_range.x:
		for y in load_range.y:
			var pos = Vector2(x,y)
			alt = round(noise.get_noise_2dv(pos)*100.0)
			if alt > 10:
				set_cell(pos, 0, Vector2(1,1))
				
	for x in load_range.x:
		for y in load_range.y:
			pass
			'''if alt > 1:
				var surrounding : Array[int] = [get_cell_alternative_tile(pos+Vector2i(1,1))*10), 
											round(noise.get_noise_2dv(pos+Vector2i(-1,1))*10), 
											round(noise.get_noise_2dv(pos+Vector2i(1,-1))*10), 
											round(noise.get_noise_2dv(pos+Vector2i(-1,-1))*10)]
				#make atlas
				var atlas = Vector2i(1,1)
				if surrounding[0] != alt or surrounding[1] != alt or surrounding[2] != alt or surrounding[3] != alt:
					if 
	
				'''
