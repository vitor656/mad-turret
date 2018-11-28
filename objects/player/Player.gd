extends KinematicBody2D

onready var arrow = $Arrow
onready var push_back_vec = $PushBackRef
onready var bulletSpawnPosition = $BulletSpawnPosition1
onready var screenShake = get_parent().get_node("ScreenShake")
onready var sndShoot = $AudioShoot
onready var sndExplosion = $AudioExplosion
onready var respawnTimer = $RespawnTimer

var Bullet = preload("res://objects/bullet/Bullet.tscn")

var rotSpeed = 5
var pushBackTimeCounter = 0
var doubleClickTimeCounter = 0
var isWaitingDoubleClick = false
var motion = Vector2()
var lastMotion = Vector2()
var canShoot = true
var isAlive = true

const PUSH_FORCE = 2
const PUSH_BACK_TIME = 5
const DOUBLE_CLICK_TIME = 10

func _ready():
	pushBackTimeCounter = PUSH_BACK_TIME
	doubleClickTimeCounter = DOUBLE_CLICK_TIME
	randomize()

func _physics_process(delta):
	if isAlive:
		if Input.is_action_pressed("ui_accept"):
			arrow.visible = false
			
			var pushDir = position - push_back_vec.global_position
			motion = pushDir * PUSH_FORCE
			lastMotion = motion
			
			pushBackTimeCounter -= 1
			if pushBackTimeCounter <= 0 && pushBackTimeCounter > -PUSH_BACK_TIME:
				motion = Vector2()
				if canShoot:
					shoot()
					canShoot = false
			elif pushBackTimeCounter <= -PUSH_BACK_TIME:
				pushBackTimeCounter = PUSH_BACK_TIME
				canShoot = true
		
		elif Input.is_action_just_released("ui_accept"):
			isWaitingDoubleClick = true

		else:
			arrow.visible = true
			rotation += rotSpeed * delta
			motion = lastMotion
		
		wait_double_click()
		wrap()
		
		move_and_slide(motion)
		check_collisions()

func die():
	isAlive = false
	sndExplosion.play()
	visible = false
	respawnTimer.start()

func check_collisions():
	if get_slide_count() > 0:
		for colIndex in get_slide_count():
			var collider = get_slide_collision(colIndex).get_collider()
			
			if "Enemy" in collider.name:
				die()

func shoot():
	var bullet = Bullet.instance()
	get_parent().add_child(bullet)
	var p = randi() % 3 + 1
	bullet.start(get_bullet_spawn_position(p), get_bullet_direction(p), global_rotation)
	sndShoot.play()
	
	screenShake.start()
	
func get_bullet_direction(p):
	return get_node("BulletSpawnPosition" + str(p)).global_position - global_position
	
func get_bullet_spawn_position(p):
	return get_node("BulletSpawnPosition" + str(p)).global_position
	
func invert_rotation():
	rotSpeed *= -1

func wrap():
	if position.x < 0:
		position = Vector2( get_viewport_rect().size.x, position.y)
	elif position.x > get_viewport_rect().size.x:
		position = Vector2(0, position.y)
	
	if position.y < 0:
		position = Vector2(position.x, get_viewport_rect().size.y)
	elif position.y > get_viewport_rect().size.y:
		position = Vector2(position.x, 0)

func wait_double_click():
	if isWaitingDoubleClick:
		doubleClickTimeCounter -= 1
		
		if Input.is_action_just_pressed("ui_accept"):
			invert_rotation()
		
		if doubleClickTimeCounter <= 0:
			isWaitingDoubleClick = false
			doubleClickTimeCounter = DOUBLE_CLICK_TIME


func _on_RespawnTimer_timeout():
	get_tree().change_scene( "scenes/Game.tscn" )
