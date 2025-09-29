extends Node2D
const player_texture = preload("res://PlayerFrames/DownSlow/pixil-frame-1.png")
@onready var cutscene = $CutScene
func _ready() -> void:
	if GLOBALS.story:
		await cutscene.speak("this negative speed is weird...",player_texture , 3, 0.5)
		await cutscene.speak("I thiink I we3nnttt t000o0o ffffaaassssstttt",player_texture , 3, 0.5)
		await cutscene.speak("emit ni kcabb gniogg m'III",player_texture , 3, 0.5)
		get_tree().change_scene_to_file("res://game.tscn")
				
