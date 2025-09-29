extends Node2D
const player_texture = preload("res://PlayerFrames/DownSlow/pixil-frame-1.png")
@onready var cutscene = $CutScene
func _ready() -> void:
	if GLOBALS.story:
		await cutscene.speak("I never liked the fish.",player_texture , 3, 0.5)
		await cutscene.speak("but for the most part I left them alone",player_texture , 3, 0.5)
		await cutscene.speak("Until one day",player_texture , 3, 0.5)
		await cutscene.speak("When I left my honey unattended",player_texture , 4, 0.5)
		await cutscene.speak("and when I came back it was gone",player_texture , 5, 0.5)
		await cutscene.speak("I didn't see who it was...",player_texture , 4, 0.5)
		await cutscene.speak("but I smelled something...",player_texture , 4, 0.5)
		await cutscene.speak("FISH!",player_texture , 3, 0.5)
		get_tree().change_scene_to_file("res://game.tscn")
				
