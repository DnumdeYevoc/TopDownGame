extends Timer
@export var timer_done := true
func _ready() -> void:
	wait_time = 9999999
	autostart = false
	one_shot = true
	timeout.connect(_on_timeout)

func _on_timeout() -> void:
	timer_done = true
