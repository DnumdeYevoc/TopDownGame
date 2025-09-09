@tool
extends TileMapLayer

var random = RandomNumberGenerator.new()

@onready var player = $"../Player"

@export var world_seed := 0
@export var noise = FastNoiseLite.new()
@export var threshold :int= 0
@export var render_dis = Vector2i(50, 38)
@export var randomise_seed :bool = false:
	set(new):
		randomise_seed = new
		world_seed = random.randi_range(0,99999999)
		noise.seed = world_seed
		randomise_seed = false
@export var height := 10
@export var reload :bool = false:
	set(new):
		reload = new
		generate_tiles(render_dis)
		reload = false
var alt : float
var ref_point = Vector2i(0,0)

func _ready() -> void:
	noise.seed = world_seed
	noise.frequency = 0.03
	noise.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	noise.fractal_weighted_strength = 1
	ref_point = player.position
	generate_tiles(render_dis)
	
func _physics_process(delta: float) -> void:
	update_tiles(render_dis)
func generate_tiles(size):
	clear()
	for x in size.x:
		for y in size.y:
			#make different so that player doesnt lag behind
		
			var pos = Vector2(int(player.position.x)/32-size.x/2+x,int(player.position.y)/32-size.y/2+y)
			alt = round(noise.get_noise_2dv(pos)*100.0)
			if alt - pos.y/4 > threshold:
				set_cell(pos, 0, Vector2(2,1))
				
	for x in size.x:
		for y in size.y:
			#if its not being layered over
			#if it exists
			var pos = Vector2i(int(player.position.x)/32-size.x/2+x,int(player.position.y)/32-size.y/2+y)
			var cell_id = get_cell_source_id(pos)
			if cell_id != -1:
				var surrounding : Array[int] = [get_cell_source_id(pos+Vector2i(0,1)), 
											get_cell_source_id(pos+Vector2i(0,-1)), 
											get_cell_source_id(pos+Vector2i(1,0)), 
											get_cell_source_id(pos+Vector2i(-1,0))]
				#make atlas
				var atlas = Vector2i(2,1)
				if surrounding[0] == cell_id:
					atlas.y += 2
				if surrounding[1] == cell_id:
					atlas.y += -1
				if surrounding[2] == cell_id:
					atlas.x += 1
				if surrounding[3] == cell_id:
					atlas.x += -2
				set_cell(pos, cell_id, atlas)
func update_tiles(size):
	if int(player.position.distance_to(ref_point))/32> 10:
		ref_point = player.position
		clear()
		for x in size.x:
			for y in size.y:
				var pos = Vector2(int(ref_point.x)/32-size.x/2+x,int(ref_point.y)/32-size.y/2+y)
				#if its not already loaded
				if get_cell_source_id(pos) != 1:
					alt = round(noise.get_noise_2dv(pos)*100.0)
					if alt -pos.y/4 > threshold:
						set_cell(pos, 0, Vector2(1,2))
		for x in size.x:
			for y in size.y:
				#if its not being layered over
				#if it exists
				var pos = Vector2i(int(ref_point.x)/32-size.x/2+x,int(ref_point.y)/32-size.y/2+y)
				var cell_id = get_cell_source_id(pos)
				if cell_id != -1:
					var surrounding : Array[int] = [get_cell_source_id(pos+Vector2i(0,1)), 
												get_cell_source_id(pos+Vector2i(0,-1)), 
												get_cell_source_id(pos+Vector2i(1,0)), 
												get_cell_source_id(pos+Vector2i(-1,0))]
					#autotiling
					#if its an edge tile
					if surrounding[0] != cell_id or surrounding[1] != cell_id or surrounding[2] != cell_id or surrounding[3] != cell_id:
						var atlas = Vector2i(2,1)
						if surrounding[0] == cell_id:
							atlas.y += 2
						if surrounding[1] == cell_id:
							atlas.y += -1
						if surrounding[2] == cell_id:
							atlas.x += 1
						if surrounding[3] == cell_id:
							atlas.x += -2
						set_cell(pos, cell_id, atlas)
			
