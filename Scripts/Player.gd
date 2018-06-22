extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 250
const JUMP_HEIGHT = -1050

const OFFSETY = 18
const OFFSETX = 20
const OFFSETYD = -10
const TOPOFF = -40

var motion = Vector2()

export (PackedScene) var projectile
export (PackedScene) var sniper
export (PackedScene) var hmg
export (PackedScene) var sg
export (PackedScene) var penetradora

var shoot_x = 1
var aux_shoot_x = 1
var shoot_y = 0
var shooting = false
var life = 100
var invencible = false
var weapon = 0
var ammo = 0
var muerto = false

func _ready():
	#$AnimatedSprite.play("idle_right")
	sniper = load("res://Scenes/Sniper.tscn")
	hmg = load("res://Scenes/HMG.tscn")
	sg = load("res://Scenes/Shotgun.tscn")
	penetradora = load("res://Scenes/Penetradora.tscn")
	pass
	
func _physics_process(delta):
	if weapon == 0:
		get_parent().get_node("IconoAmmo").texture = load("res://Sprites/Icons/Maiz.png")
	elif weapon == 1:
		get_parent().get_node("IconoAmmo").texture = load("res://Sprites/Icons/Tomate.png")
	elif weapon == 2:
		get_parent().get_node("IconoAmmo").texture = load("res://Sprites/Icons/Calabaza.png")
	elif weapon == 3:
		get_parent().get_node("IconoAmmo").texture = load("res://Sprites/Icons/Rabano.png")
	elif weapon == 4:
		get_parent().get_node("IconoAmmo").texture = load("res://Sprites/Icons/Zanahoria.png")
	
	if !muerto:
		motion.y += ACCELERATION
		shoot_y = 0
		
		if ammo <= 0:
			ammo = 0
			get_parent().get_node("LabelAmmo").text = "UNLIMITED"
			weapon = 0
			
		if Input.is_action_pressed("ui_right"):
			motion.x += ACCELERATION
			if motion.x > MAX_SPEED:
				motion.x = MAX_SPEED
			shoot_x = 1
			aux_shoot_x = shoot_x
			if Input.is_action_pressed("ui_up"):
				if(is_on_floor()):
					$AnimatedSprite.animation = "diag_right"
			else:
				if(is_on_floor()):
					$AnimatedSprite.animation = "moving_right"
			
			#$Sprite.flip_h = false
			#$Sprite.play("Run")
		elif Input.is_action_pressed("ui_left"):
			motion.x -= ACCELERATION
			if motion.x < -MAX_SPEED:
				motion.x = -MAX_SPEED
			shoot_x = -1
			aux_shoot_x = shoot_x
			if Input.is_action_pressed("ui_up"):
				if(is_on_floor()):
					$AnimatedSprite.animation = "diag_left"
			else:
				if(is_on_floor()):
					$AnimatedSprite.animation = "moving_left"
			#$Sprite.flip_h = true
			#$Sprite.play("Run")
		else:
			if shoot_x == 1:
				if(is_on_floor()):
					$AnimatedSprite.animation = "idle_right"
			if shoot_x == -1:
				if(is_on_floor()):
					$AnimatedSprite.animation = "idle_left"
				
			motion.x = 0
		if Input.is_action_pressed("ui_up") and is_on_floor():
			shoot_y = -1
			if motion.x == 0:
				shoot_x = 0
				$AnimatedSprite.animation = "up"
			else:
				shoot_y = -0.25
				shoot_x = aux_shoot_x
					
		else:
			shoot_x = aux_shoot_x
		
		if is_on_floor():
			if Input.is_action_just_pressed("ui_select"):
				motion.y = JUMP_HEIGHT
				if shoot_x == 1:
					$AnimatedSprite.animation = "jump_right"
					#$AnimatedSprite.play()
				if shoot_x == -1:
					$AnimatedSprite.animation = "jump_left"
					#$AnimatedSprite.play()
				get_parent().get_node("SoundEffects/Jump").play()
		#else:
			#$Sprite.play("Jump")
		if Input.is_action_pressed("ui_shoot") and !shooting:
			match weapon:
				0:
					var new_projectile = projectile.instance()
					if(shoot_y):
						new_projectile.rotation_degrees =  -90 + 45*shoot_x
					else:
						new_projectile.scale.x = new_projectile.scale.x*shoot_x
					new_projectile.position.x = position.x + OFFSETX * shoot_x
					var localOFFY
					if(shoot_y == -0.25):
						localOFFY = OFFSETYD
					elif(shoot_y == -1):
						localOFFY = TOPOFF
					else:
						localOFFY = OFFSETY
					new_projectile.position.y = position.y + localOFFY
					new_projectile.xdirection = shoot_x 
					new_projectile.ydirection = shoot_y
					get_parent().add_child(new_projectile)
					shooting = true
					$ShootingTimer.wait_time = 0.25
					$ShootingTimer.start()
					get_parent().get_node("SoundEffects/NormalShot").play()
				1:
					var new_projectile = sniper.instance()
					if(shoot_y):
						new_projectile.rotation_degrees =  -90 + 45*shoot_x
					else:
						new_projectile.scale.x = new_projectile.scale.x*shoot_x
					new_projectile.position.x = position.x + OFFSETX * shoot_x
					var localOFFY
					if(shoot_y == -0.25):
						localOFFY = OFFSETYD
					elif(shoot_y == -1):
						localOFFY = TOPOFF
					else:
						localOFFY = OFFSETY
					new_projectile.position.y = position.y + localOFFY
					new_projectile.xdirection = shoot_x 
					new_projectile.ydirection = shoot_y
					get_parent().add_child(new_projectile)
					shooting = true
					$ShootingTimer.wait_time = 2
					$ShootingTimer.start()
					get_parent().get_node("SoundEffects/Sniper").play()
				2:
					var new_projectile = hmg.instance()
					if(shoot_y):
						new_projectile.rotation_degrees =  -90 + 65*shoot_x
					else:
						new_projectile.scale.x = new_projectile.scale.x*shoot_x
					new_projectile.position.x = position.x + rand_range(-10,20)*shoot_y + OFFSETX * shoot_x
					var localOFFY
					if(shoot_y == -0.25):
						localOFFY = OFFSETYD
					elif(shoot_y == -1):
						localOFFY = TOPOFF
					else:
						localOFFY = OFFSETY
					new_projectile.position.y = position.y + rand_range(-10,20)*shoot_x + localOFFY
					new_projectile.xdirection = shoot_x
					new_projectile.ydirection = shoot_y
					get_parent().add_child(new_projectile)
					shooting = true
					$ShootingTimer.wait_time = 0.1
					$ShootingTimer.start()
					get_parent().get_node("SoundEffects/NormalShot").play()
				3:
					var new_projectile = sg.instance()
					if(shoot_y):
						new_projectile.rotation_degrees =  -90 + 45*shoot_x
					else:
						new_projectile.scale.x = new_projectile.scale.x*shoot_x
					new_projectile.position.x = position.x + OFFSETX * shoot_x
					var localOFFY
					if(shoot_y == -0.25):
						localOFFY = OFFSETYD
					elif(shoot_y == -1):
						localOFFY = TOPOFF
					else:
						localOFFY = OFFSETY
					new_projectile.position.y = position.y + localOFFY
					new_projectile.xdirection = shoot_x 
					new_projectile.ydirection = shoot_y
					get_parent().add_child(new_projectile)
					shooting = true
					$ShootingTimer.wait_time = 1
					$ShootingTimer.start()
					get_parent().get_node("SoundEffects/ShotGun").play()
				4:
					var new_projectile = penetradora.instance()
					if(shoot_y):
						new_projectile.rotation_degrees =  -90 + 65*shoot_x
					else:
						new_projectile.scale.x = new_projectile.scale.x*shoot_x
					new_projectile.position = position 
					new_projectile.xdirection = shoot_x + OFFSETX * shoot_x
					new_projectile.ydirection = shoot_y
					new_projectile.position.x = position.x + OFFSETX * shoot_x
					var localOFFY
					if(shoot_y == -0.25):
						localOFFY = OFFSETYD
					elif(shoot_y == -1):
						localOFFY = TOPOFF
					else:
						localOFFY = OFFSETY
					new_projectile.position.y = position.y + localOFFY
					new_projectile.xdirection = shoot_x 
					new_projectile.ydirection = shoot_y
					get_parent().add_child(new_projectile)
					shooting = true
					$ShootingTimer.wait_time = 0.25
					$ShootingTimer.start()
					get_parent().get_node("SoundEffects/NormalShot").play()
			
			if weapon != 0:
				ammo -= 1
	
	if(weapon != 0):
		get_parent().get_node("LabelAmmo").text = "%d" % ammo
		
	$AnimatedSprite.play()
		
	motion = move_and_slide(motion, UP)
	pass

func _on_ShootingTimer_timeout():
	shooting = false

func _hitPlayer(dmg):
	if !invencible:
		life -= dmg
		invencible = true
		$InvencibleTimer.start()
		
		if life < 0:
			life = 0
			
		get_parent().get_node("LabelHP").text = "%d%%" % life
		
		if life == 0 and !muerto:
			muerto = true
			if motion.x < 0:
				$AnimatedSprite.animation = "die_left"
			else:
				$AnimatedSprite.animation = "die_right"
			motion.x = 0
			
			var fade = get_parent().get_node("Fade2")
			fade._loadScene("res://Scenes/Menu.tscn")
			emit_signal("game_over")
	
func _on_InvencibleTimer_timeout():
	invencible = false
