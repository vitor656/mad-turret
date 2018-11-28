extends Control

onready var lblScore = $Container/Label

func update_score_label(score):
	lblScore.text = "Score: " + str(score)