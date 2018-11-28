extends Node

const Enemy = preload("res://objects/enemies/enemy_1/Enemy.tscn")
onready var spawnTimer = $SpawnTimer
onready var difficulTimer = $DifficulTimer

var currentSpawnWaitTime = 5
var difficulTimerWaitTime = 10

func _ready():
	randomize()
	spawnTimer.wait_time = currentSpawnWaitTime
	difficulTimer.wait_time = difficulTimerWaitTime
	spawnTimer.start()
	difficulTimer.start()
	
func spawnEnemy():
	var enemy = Enemy.instance()
	get_parent().add_child(enemy)
	enemy.position = get_random_position()
	
func get_random_position():
	var newPosition = Vector2()
	var corner = randi() % 4
	
	match corner:
		0:
			#left
			newPosition = Vector2(0, randi() % 240)
		1:
			#right
			newPosition = Vector2(320, randi() % 240)
		2:
			#up
			newPosition = Vector2(randi() % 320, 0)
		3:
			#down
			newPosition = Vector2(randi() % 320, 240)
	
	return newPosition


func _on_SpawnTimer_timeout():
	spawnEnemy()


func _on_DifficulTimer_timeout():
	currentSpawnWaitTime /= 1.5
	spawnTimer.wait_time = currentSpawnWaitTime
