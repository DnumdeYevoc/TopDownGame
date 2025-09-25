extends ColorRect

@onready var person: Sprite2D = $Speaker

@onready var label: Label = $Label

func speak(speech, speaker, time, scal):
	visible = true
	person.texture = speaker
	label.text = speech
	label.scale =Vector2(1,1)*( scal/2.0)
	var timer = get_tree().create_timer(time)
	await timer.timeout
	visible = false
	return true
