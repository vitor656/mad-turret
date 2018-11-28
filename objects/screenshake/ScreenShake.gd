extends Node

onready var camera = get_parent().get_node("Camera2D")
onready var tween = $Tween
onready var frequencyTimer = $FrequencyTimer
onready var durationTimer = $DurationTimer

var amplitude = 0

func start(_duration = 0.1, _frequency = 15, _amplitude = 1):
	amplitude = _amplitude
	
	durationTimer.wait_time = _duration
	frequencyTimer.wait_time = 1 / float(_frequency)
	
	durationTimer.start()
	frequencyTimer.start()
	
	shake()

func shake():
	var rand = Vector2(rand_range(-amplitude, amplitude), rand_range(-amplitude, amplitude))
	
	tween.interpolate_property(camera, "offset", camera.offset, rand,frequencyTimer.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func reset():
	tween.interpolate_property(camera, "offset", camera.offset, Vector2(), frequencyTimer.wait_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
func _on_FrequencyTimer_timeout():
	shake()


func _on_DurationTimer_timeout():
	reset()
	frequencyTimer.stop()
