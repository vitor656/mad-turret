extends KinematicBody2D

const SPEED = 20

var motion = Vector2()

func start(_position, _direction, _rotation):
	position = _position
	rotation = _rotation
	
	motion = _direction * SPEED

func _physics_process(delta):
	move_and_slide( motion )
	
	if get_slide_count() > 0:
		for colIndex in get_slide_count():
			var collider = get_slide_collision(colIndex).get_collider()
			
			if "Enemy" in collider.name:
				queue_free()
				collider.take_damage()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
