extends Resource

@export var enemy_index : int 

@export var sprite_frames : SpriteFrames 
@export var collision_radius :int 
@export var collision_height :int 
@export var collision_rotation :int 
@export var texture_scale :Vector2
@export var speed :int 
@export var hit_speed :float
@export var hit_damage :int 

@export var health :float
@export var heal_factor : float
@export var blood_heal_factor : float

@export var spawn_time :int 
@export var attack_time :float

@export var max_spawn_amount : int
@export var min_spawn_amount :int

@export var can_rotate : bool 
@export var clumping : int 
@export var crowding : int 

@export var experience_value :int
@export var min_y :int
@export var level_unlock :int
