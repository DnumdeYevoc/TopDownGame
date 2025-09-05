@tool
extends TileMapLayer

var random = RandomNumberGenerator.new()

@export var world_seed := 0
@export var noise = FastNoiseLite.new()
@export var threshold :int= 10
@export var load_range = Vector2(100, 100)
@export var randomise_seed :bool = false:
	set(new):
		randomise_seed = new
		world_seed = random.randi_range(0,99999999)
		randomise_seed = false

@export var reload :bool = false:
	set(new):
		reload = new
		generate_buildings()
		reload = false
		
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
			if alt > threshold:
				set_cell(pos, 0, Vector2(2,1))
				
	for x in load_range.x:
		for y in load_range.y:
			#if it exists
			var pos = Vector2i(x,y)
			var cell_id = get_cell_source_id(pos)
			if cell_id != -1:
				var surrounding : Array[int] = [get_cell_source_id(pos+Vector2i(0,1)), 
											get_cell_source_id(pos+Vector2i(0,-1)), 
											get_cell_source_id(pos+Vector2i(1,0)), 
											get_cell_source_id(pos+Vector2i(-1,0))]
				#make atlas
				var atlas = Vector2i(2,1)
				if surrounding[0] == cell_id:
					atlas += Vector2i(0,2)
				if surrounding[1] == cell_id:
					atlas += Vector2i(0,-1)
				if surrounding[2] == cell_id:
					atlas += Vector2i(1,0)
				if surrounding[3] == cell_id:
					atlas += Vector2i(-2,0)
				set_cell(pos, cell_id, atlas)
