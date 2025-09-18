extends Resource

@export var speed :int = 200
@export var spawn_time :int = 2
@export var enemy_index : int = 0
@export var max_spawn_amount : int = 20
#average spawn amount = max_spawn_amount* 1/spawn_chance 
@export var spawn_chance :float= 5
@export var can_rotate : bool = false
