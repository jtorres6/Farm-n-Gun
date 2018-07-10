extends KinematicBody2D

#************* Player Parameters: ******************

var life = 100

#******** Direction and facing stuff ***************

var input_direction = 0
var direction = 0
var facing_direction = 1
var y_orientation = 0

#********** Movement Parameters *********************

var speed_x = 0
var speed_y = 0
var velocity = Vector2()
const MAX_SPEED = 500
const ACCELERATION = 1200
const DECELERATION = 2000
const GRAVITY = 2000
const JUMP_FORCE = 800
const MAX_FALL_SPEED = 600

#********** Another control params *******************

var platformNameArray = ['Plataforma', 'Plataforma2']
var isOnPlatform = false
var canIShoot = true
var ammoArray = []
var currentAmmo = 0

#*****************************************************

func _ready():
	# Load ammo:
	var projectile = load('res://Scenes/Projectile.tscn')
	ammoArray.append(projectile)		# 0 Basic Ammo
	projectile = load('res://Scenes/Sniper.tscn')
	ammoArray.append(projectile)		# 1 Sniper
	projectile = load('res://Scenes/Shotgun.tscn')
	ammoArray.append(projectile)		# 2 Shotgun
	projectile = load('res://Scenes/Penetradora.tscn')
	ammoArray.append(projectile)		# 3 Carrot


func _input(event):
	# JUMP:
	if Input.is_action_pressed('ui_accept') and is_on_floor():
		speed_y = - JUMP_FORCE


func InstanceBullet():
	# FIXME:
	var bullet = ammoArray[currentAmmo].instance()
	bullet.ydirection = y_orientation
	
	if y_orientation:
		bullet.xdirection = 0
	else:
		bullet.xdirection = facing_direction

	bullet.position = self.position
	$ShootDelay.wait_time = bullet.delay
	get_parent().add_child(bullet)
	$ShootDelay.start()


func _physics_process(delta):

	# Check movement orientation:
	if input_direction:
		direction = input_direction
		if is_on_floor():
			facing_direction = input_direction
			
	# y orientation:
	if Input.is_action_pressed('ui_up'):
		y_orientation = -1
	elif Input.is_action_pressed('ui_down') and not is_on_floor():
		y_orientation = 1
	else:
		y_orientation = 0
	
	if Input.is_action_pressed("ui_left"):
		input_direction = -1
	elif Input.is_action_pressed("ui_right"):
		input_direction = 1
	else:
		input_direction = 0
	
	# Set speed:
	if input_direction == - direction:
		speed_x /= 3
	if input_direction:
		speed_x += ACCELERATION * delta
	else:
		speed_x -= DECELERATION * delta
		
	speed_y += GRAVITY * delta

	# Limit speed to MAX value:
	speed_x = clamp(speed_x, 0, MAX_SPEED)
	
	if speed_y > MAX_FALL_SPEED:
		speed_y = MAX_FALL_SPEED
	
	# Set velocity vector and move player:
	velocity.x = speed_x * direction
	velocity.y = speed_y
	move_and_slide(velocity, Vector2(0,-1))
	
	# Check if player is on a platform
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.name in platformNameArray:
			isOnPlatform = true
		else:
			isOnPlatform = false
			
	# If player is over a platform and press 'down', it falls:
	if isOnPlatform and Input.is_action_just_pressed('ui_down'):
		get_node('CollisionShape2D').disabled = true
	else:
		get_node('CollisionShape2D').disabled = false
		
	# Shoot
	if Input.is_action_pressed('ui_shoot') and canIShoot:
		canIShoot = false
		InstanceBullet()


func _on_ShootDelay_timeout():
	canIShoot = true
