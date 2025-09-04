extends TileMapLayer

@onready var noise := FastNoiseLite.new()
var load_range = Vector2(20, 20)
var alt : float

func _ready() -> void:
	generate_buildings()

func generate_buildings():
	for x in load_range.x:
		for y in load_range.y:
			var pos = Vector2(x,y)
			alt = round(noise.get_noise_2dv(pos)*10)
			set_cell(pos, 1, Vector2(1,1))
			
	for x in load_range.x:
		for y in load_range.y:
			if alt > 1:
				var surrounding : Array[int] = [get_cell_alternative_tile(pos+Vector2i(1,1))*10), 
											round(noise.get_noise_2dv(pos+Vector2i(-1,1))*10), 
											round(noise.get_noise_2dv(pos+Vector2i(1,-1))*10), 
											round(noise.get_noise_2dv(pos+Vector2i(-1,-1))*10)]
				#make atlas
				var atlas = Vector2i(1,1)
				if surrounding[0] != alt or surrounding[1] != alt or surrounding[2] != alt or surrounding[3] != alt:
					if 
	
				
