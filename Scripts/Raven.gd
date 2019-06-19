extends KinematicBody2D

var player
var playerPos
var ravenPos
var xdirection
var ydirection
var speedx
var speedy


var life = 100
var MAX_SPEED = 120
var speedVector
var damage = 10

var heColisionado

func _ready():
	set_process(true)
	heColisionado = false

func _process(delta):
	player = get_parent().get_node("Player")
	playerPos = player.position
	ravenPos = self.position
	
	var xdir = (playerPos.x - ravenPos.x)
	
	if(xdir < 0):
		xdirection = -1
		get_node("Visuals").set_scale(Vector2(1,1))
	else:
		xdirection = 1
		get_node("Visuals").set_scale(Vector2(-1,1))
	
	var ydir = (playerPos.y - ravenPos.y)
	
	if(ydir < 0):
		ydirection = -1
	else:
		ydirection = 1
	
	speedx = abs((playerPos.x - ravenPos.x))
	speedy = abs((playerPos.y - ravenPos.y))
	speedx = clamp(speedx, 0, MAX_SPEED)
	speedy = clamp(speedy, 0, MAX_SPEED)
	
	speedx = speedx * xdirection * delta
	speedy = (speedy+25) * ydirection * delta
	
	speedVector = Vector2(speedx, speedy)

	if not heColisionado:
		move_and_collide(speedVector)
	else:
		move_and_collide(speedVector * -3)

func _on_Timer_timeout():
	heColisionado = false


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		if body.get("invencible") == false:
			body.HitPlayer(damage)
			heColisionado = true
			get_node("Timer").start()
			get_node("SoundEffects/HitPlayer").play()
	elif ("Projectile" in body.name) or ("Penetradora" in body.name) or ("Sniper" in body.name) or ("Shotgun" in body.name) or ("HMG" in body.name):
		get_parent().get_node("SoundEffects/HitCrown").play()
		life -= body.damage
		
		if not body.penetracion:
			body.queue_free()
			
	if life <= 0:
		get_parent().get_node("RavenManager").contador_ravens -= 1
		queue_free()
