extends Node2D


func _on_texture_button_pressed() -> void:
	if GLOBALS.story:
		get_tree().change_scene_to_file("res://Story Scenes/prologue.tscn")
	else:
		get_tree().change_scene_to_file("res://game.tscn")


func _on_check_button_toggled(toggled_on: bool) -> void:
	GLOBALS.tutorial = toggled_on


func _on_check_button_2_toggled(toggled_on: bool) -> void:
	GLOBALS.story = toggled_on
