extends Node
@onready var cut_scene: ColorRect = $Player/CutScene
var one_shot := true
var one_shot1 := true
var one_shot2 := true
var one_shot3 := true
var one_shot4 := true
@onready var player: CharacterBody2D = $Player
const player_texture = preload("res://PlayerFrames/DownSlow/pixil-frame-1.png")
const compass_texture = preload("res://Compass.png")
const absolute_compass_texture = preload("res://AbsoluteCompass.png")
const shark =preload("res://SharkFrames/pixil-frame-7.png")


func _process(delta: float) -> void:
	if GLOBALS.tutorial:
		if GLOBALS.level == 0:
			if one_shot:
				one_shot= false
				await cut_scene.speak("ACCELERATE WITH LEFT CLICK",compass_texture , 3, 0.5)
				await cut_scene.speak("DECCELERATE WITH RIGHT CLICK",compass_texture , 3, 0.5)
				GLOBALS.level=1
				one_shot1= true
		if GLOBALS.level == 1:
			if one_shot1:
				one_shot1 = false
				var timer = get_tree().create_timer(10)
				await timer.timeout
				await cut_scene.speak("These fish look yummy!",player_texture , 3, 0.5)
				var timer2 = get_tree().create_timer(2)
				await timer2.timeout
				await cut_scene.speak("Hmm... Why are they angry at me?",player_texture , 3, 0.5)
				var timer3= get_tree().create_timer(2)
				await timer3.timeout
				await cut_scene.speak("HIT C TO ATTACK",compass_texture , 3, 0.5)
				one_shot2 = true
				
		if GLOBALS.level == 2:
			if one_shot2:
				one_shot2 = false
				await cut_scene.speak("This is weird... But yummy!",player_texture , 5, 0.5)
				await cut_scene.speak("I feel faster and stronger now!", player_texture, 5, 0.5)
				var timer3= get_tree().create_timer(2)
				await timer3.timeout
				await cut_scene.speak("ACCELERATE TO YOUR NEW MAX SPEED", compass_texture, 5, 0.4)
				
				one_shot3 = true
		if GLOBALS.level == 4:
			if one_shot3:
				one_shot3 = false
				await cut_scene.speak("Woah I've never felt this speedy before",player_texture , 3, 0.4)
				var timer2= get_tree().create_timer(2)
				await timer2.timeout
				await cut_scene.speak("its like some sort of...", player_texture, 3, 0.5)
				await cut_scene.speak("... speed force", player_texture, 3, 0.5)
				var timer3= get_tree().create_timer(2)
				await timer3.timeout
				await cut_scene.speak("it's got to be from the fish ",player_texture , 3, 0.5)
				var timer4= get_tree().create_timer(2)
				await timer4.timeout
				await cut_scene.speak("they seem to be coming from the south...",player_texture , 3, 0.4)
				await cut_scene.speak("Let's get to the bottom of this. ",player_texture , 3, 0.5)
				var timer5= get_tree().create_timer(2)
				await timer5.timeout
				await cut_scene.speak("HEAD SOUTH",compass_texture , 8, 0.5)
				one_shot4 = true
		if GLOBALS.level <=4 and player.position.y > 5100:
			if one_shot4:
				one_shot4 = false
				var timer5= get_tree().create_timer(10)
				await timer5.timeout
				await cut_scene.speak("These guys are more angry! AHHHHHHHHHHHHHHHHHHHH",player_texture , 5, 0.5)
				await cut_scene.speak("EVERYTHING IS HAPPENING SO FAST",player_texture , 3, 0.5)
				await cut_scene.speak("If only there was a way to slow it down...",player_texture , 3, 0.4)
				var timer= get_tree().create_timer(2)
				await timer.timeout
				await cut_scene.speak("HIT SHIFT KEY",compass_texture , 3, 0.5)
				await Input.is_action_just_pressed("KEY_SHIFT") == true
				await cut_scene.speak("...woah...",player_texture , 3, 0.5)
				var timer2= get_tree().create_timer(3)
				await timer2.timeout
				await cut_scene.speak("I feel like I could use all this energy somehow...",player_texture , 3, 0.4)
				var timer1= get_tree().create_timer(3)
				await timer1.timeout
				await cut_scene.speak("HIT SPACEBAR",compass_texture , 3, 0.5)
				
				var timer7= get_tree().create_timer(20)
				await timer7.timeout
				await cut_scene.speak("Who's behind all this?...",player_texture , 5, 0.5)
				await cut_scene.speak("they must be further south, in the ocean...",player_texture , 5, 0.4)
				await cut_scene.speak("STAY ON LAND U SPEEDY BEAR",shark , 5, 0.5)
				await cut_scene.speak("ABSOLUTE TUTORIAL",absolute_compass_texture , 8, 0.5)
				GLOBALS.tutorial = false
				
