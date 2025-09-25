extends Node
@onready var cut_scene: ColorRect = $Player/CutScene
var one_shot := true
var one_shot1 := true
var one_shot2 := true
var one_shot3 := true
var one_shot4 := true
var one_shot5 := true
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
				await cut_scene.speak("ACCELERATE WITH LEFT CLICK",compass_texture , 5, 0.5)
				await cut_scene.speak("DECCELERATE WITH RIGHT CLICK",compass_texture , 3, 0.5)
				await cut_scene.speak("HIT C TO ATTACK",compass_texture , 5, 0.5)
				GLOBALS.level=1
				one_shot1= true
		if GLOBALS.level == 3:
			if one_shot1:
				one_shot1 = false
				await cut_scene.speak("ACCELERATE TO YOUR NEW MAX SPEED", compass_texture, 8, 0.5)
				one_shot2 = true
		if GLOBALS.level == 5:
			if one_shot2:
				one_shot2 = false
				await cut_scene.speak("HOLD SHIFT KEY TO SLOW DOWN TIME",compass_texture , 5, 0.5)
				await cut_scene.speak("SPEED UP AND HIT SPACEBAR",compass_texture , 5, 0.5)
				
		if GLOBALS.level >5 and player.position.y < 7500:
				await cut_scene.speak("HEAD SOUTH",compass_texture , 2, 0.5)
				one_shot4 = true
		if GLOBALS.level >5 and player.position.y > 7500:
			if one_shot4:
				one_shot4 = false
				var timer7= get_tree().create_timer(3)
				await timer7.timeout
				if GLOBALS.story:
					await cut_scene.speak("WHICH OF YOU TOOK MY HONEY?...",player_texture , 5, 0.5)
					await cut_scene.speak("they must be further south, in the ocean...",player_texture , 5, 0.4)
					await cut_scene.speak("STAY ON LAND U SPEEDY BEAR",shark , 5, 0.5)
				else:
					await cut_scene.speak("STAY ALIVE, SPEEDY BEAR",compass_texture , 5, 0.5)
				await cut_scene.speak("ABSOLUTE TUTORIAL",absolute_compass_texture , 8, 0.5)
				one_shot5 = true
				GLOBALS.tutorial = false
	if player.negative:
		if one_shot5:
			one_shot5 = false
			await cut_scene.speak("YOUR SPEED CAN NOW GO NEGATIVE",absolute_compass_texture , 8, 0.5)
