extends KinematicBody2D

onready var sndExplosion = $AudioExplosion
onready var deadTimer = $DeadTimer

var life = 3
var speed = 5
var motion = Vector2()

func _physics_process(delta):
	var player = locate_player()
	
	if player != null:
		motion = player.position - position
		rotation = motion.angle()
		
	move_and_slide(motion.normalized() * speed)
	
func locate_player():
	return get_parent().get_node("Player")
	
func take_damage():
	life -= 1
	if life <= 0:
		visible = false
		$CollisionShape2D.disabled = true
		get_parent().update_score()
		sndExplosion.play()
		deadTimer.start()

func _on_DeadTimer_timeout():
	queue_free()
