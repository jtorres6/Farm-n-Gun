extends KinematicBody2D

var player
var playerPos
var ravenPos
var xdirection
var ydirection
var speedx
var speedy
var life = 100
var MAX_SPEED = 100
var speedVector
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
		get_node("Sprite").flip_h = false
	else:
		xdirection = 1
		get_node("Sprite").flip_h = true
	
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
	
	if(!heColisionado):
		move_and_collide(speedVector)
	else:
		move_and_collide(speedVector * -3)

func _on_Area2D_body_entered(body):
	if not body.get("penetracion") == null:
		var penetracion = body.get("penetracion")
		life -= body.get("damage")
		get_parent().get_node("SoundEffects/HitCrown").play()
	
		if !penetracion:
			body.queue_free()
		
	if life <= 0:
		get_parent().get_node("RavenManager").contador_ravens -= 1
		queue_free()
		
	if body.name == "Player":
		if body.get("invencible") == false:
			body._hitPlayer(10)
			heColisionado = true
			get_node("Timer").start()
			get_parent().get_node("SoundEffects/HitPlayer").play()


func _on_Timer_timeout():
	heColisionado = false
	pass
