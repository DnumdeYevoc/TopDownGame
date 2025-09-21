extends Resource

@export var enemy_index : int 
@export var texture : Texture2D 
@export var collision_radius :int 
@export var speed :int 

@export var spawn_time :int 

@export var max_spawn_amount : int 
#average spawn amount = max_spawn_amount* 1/spawn_chance 
@export var spawn_chance :float
@export var can_rotate : bool 
@export var clumping : int 
@export var crowding : int 
