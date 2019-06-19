extends KinematicBody2D

#************* Player Parameters: ******************

var life = 100
var shield = 0
var ammo = 10
var invencible = false
var dead = false

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
const JUMP_TIMER = 0.2
var rememberJumpTimer = 0.0
const GROUNDED_TIMER = 0.1
var rememberGroundedTimer = 0.0

#********** Another control params *******************

var platformNameArray = ['Plataforma', 'Plataforma2']
var isOnPlatform = false
var canIShoot = true
var ammoArray = []
var shotPoints = []
var soundEffects = []
var weapon = 0
var lastShot = false

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
	projectile = load('res://Scenes/HMG.tscn')
	ammoArray.append(projectile)		# 4 HMG
	
	# Load shot points:
	shotPoints.append(get_node('Visuals/NormalShot'))
	shotPoints.append(get_node('Visuals/UpShot'))
	shotPoints.append(get_node('Visuals/DownShot'))
	
	# Load sound effects:
	soundEffects.append(get_node('SoundEffects/NormalShot'))
	soundEffects.append(get_node('SoundEffects/Sniper'))
	soundEffects.append(get_node('SoundEffects/Shotgun'))
	soundEffects.append(get_node('SoundEffects/NormalShot'))
	soundEffects.append(get_node('SoundEffects/NormalShot'))


func InstanceBullet():
	var instantiateIn = 0
	var bullet = ammoArray[weapon].instance()
	
	# Set Bullet Direction
	bullet.ydirection = y_orientation
	if y_orientation:
		bullet.xdirection = 0
		if y_orientation == -1:
			instantiateIn = 1
		else:
			instantiateIn = 2
	else:
		bullet.xdirection = facing_direction
	
	# Set Bullet Rotation
	if facing_direction == -1:
		bullet.rotation_degrees = -180
	if y_orientation == -1:
		bullet.rotation_degrees = -90
	if y_orientation == 1:
		bullet.rotation_degrees = 90

	bullet.position = shotPoints[instantiateIn].global_position
	
	# HMG have a special behaviour:
	if weapon == 4:
		if y_orientation:
			bullet.position.x = bullet.position.x + rand_range(-10, 20)
		else:
			bullet.position.y = bullet.position.y + rand_range(-10, 20)
	
	get_parent().add_child(bullet)
	soundEffects[weapon].play()
	
	if not lastShot:
		$ShootDelay.wait_time = bullet.delay
	else:
		lastShot = false
		$ShootDelay.wait_time = 0.25
	
	$ShootDelay.start()
	
	# Manage Ammo:
	if weapon != 0:
		ammo = ammo - 1
		
	if ammo == 1 and weapon != 0:
		lastShot = true

	
func _physics_process(delta):
	# GROUNDED TIMER MANAGEMENT:
	rememberGroundedTimer -= delta
	if is_on_floor():
		rememberGroundedTimer = GROUNDED_TIMER
	
	# JUMP:
	rememberJumpTimer -= delta
	if Input.is_action_just_pressed('ui_accept'):
		rememberJumpTimer = JUMP_TIMER
		
	if rememberJumpTimer > 0 and rememberGroundedTimer > 0:
		rememberJumpTimer = 0
		rememberGroundedTimer = 0
		speed_y = - JUMP_FORCE
		get_node('SoundEffects/Jump').play()
	
	# Update GUI
	if weapon != 0:
		get_parent().get_node("LabelAmmo").text = "%d" % ammo
		
	if ammo <= 0:
		ammo = 0
		get_parent().get_node("LabelAmmo").text = "UNLIMITED"
		weapon = 0
	
	if weapon == 0:
		get_parent().get_node("IconoAmmo").texture = load("res://Sprites/Icons/Maiz.png")
	elif weapon == 1:
		get_parent().get_node("IconoAmmo").texture = load("res://Sprites/Icons/Tomate.png")
	elif weapon == 2:
		get_parent().get_node("IconoAmmo").texture = load("res://Sprites/Icons/Rabano.png")
	elif weapon == 3:
		get_parent().get_node("IconoAmmo").texture = load("res://Sprites/Icons/Zanahoria.png")
	elif weapon == 4:
		get_parent().get_node("IconoAmmo").texture = load("res://Sprites/Icons/Calabaza.png")
	
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
	
	if not dead:
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
	
#Function called when a crown hits the player:
func HitPlayer(dmg):
	if not invencible:
		if shield > 0:
			var tmp = dmg - shield
			if tmp > 0:
				life -= tmp
				shield = 0
			else:
				shield = abs(tmp)
		else:
			shield = 0
			life -= dmg
		
		invencible = true
		get_node('InvencibleTimer').start()
		
		if life < 0:
			life = 0
		
		# Update life and shield label
		get_parent().get_node("LabelHP").text = "%d%%" % life
		get_parent().get_node('LabelShield').text = "%d%%" % shield
		get_node("Visuals/Sprite").material.set_shader_param("invencible", invencible)
		## FIXMEEE:: SHADER DE CUANDO TE PEGANN
		
		if life == 0 and not dead:
			dead = true
			
			## FIXMEEEE::: ANIMACION DE MUERTE
			
			var fade = get_parent().get_node("Fade2")
			fade._loadScene("res://Scenes/TitleScreen.tscn")
			emit_signal("game_over")


func _on_InvencibleTimer_timeout():
	invencible = false
	get_node("Visuals/Sprite").material.set_shader_param("invencible", invencible)
	## FIXMEEE:: SHADER DE CUANDO TE PEGANN (???)