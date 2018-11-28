extends Node

var score

onready var ui = $UI
onready var player = $Player
onready var camera = $Camera2D

func _ready():
	score = 0
	player.position = camera.get_camera_screen_center()

func _on_Player_tree_exited():
	get_tree().change_scene( "Game.tscn" )
	
func update_score():
	score += 1
	ui.update_score_label(score)
