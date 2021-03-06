extends KinematicBody2D

var player
var vegetables = []

var targetPos
var currentTarget
var ravenPos

var xdirection
var ydirection
var speedx
var speedy

var life = 100
var MAX_SPEED = 100
var speedVector
var damage = 20

var heColisionado = false
var hasTarget = false

func _ready():
	get_node('Visuals/BlueSprite').modulate = Color("F704FF")
	player = get_parent().get_node("Player")
	
	# Load vegetables:
	vegetables.append(get_parent().get_node('Pumpkin'))
	vegetables.append(get_parent().get_node('Tomato'))
	vegetables.append(get_parent().get_node('Carrot'))
	vegetables.append(get_parent().get_node('Radish'))
	
	
func selectTarget():
	if not hasTarget:
		var posibleTargets = []
		for vgt in vegetables:
			if vgt.hay_veg:
				posibleTargets.append(vgt)
				
		if not posibleTargets.empty():
			currentTarget = posibleTargets[randi() % posibleTargets.size()] 
			targetPos =  currentTarget.position
			hasTarget = true
		else:
			currentTarget = player
			targetPos = player.position
			



func _process(delta):
	selectTarget()
	
	if currentTarget.name != "Player":
		if not currentTarget.hay_veg:
			hasTarget = false
	
	ravenPos = self.position
	var xdir = (targetPos.x - ravenPos.x)
	
	if(xdir < 0):
		xdirection = -1
		get_node("Visuals").set_scale(Vector2(1,1))
	else:
		xdirection = 1
		get_node("Visuals").set_scale(Vector2(-1,1))
	
	var ydir = (targetPos.y - ravenPos.y)
	
	if(ydir < 0):
		ydirection = -1
	else:
		ydirection = 1
	
	speedx = abs((targetPos.x - ravenPos.x))
	speedy = abs((targetPos.y - ravenPos.y))
	speedx = clamp(speedx, 0, MAX_SPEED)
	speedy = clamp(speedy, 0, MAX_SPEED)
	
	speedx = speedx * xdirection * delta
	speedy = (speedy+25) * ydirection * delta
	
	speedVector = Vector2(speedx, speedy)
	
	if not heColisionado:
		move_and_collide(speedVector)
	else:
		move_and_collide(speedVector * -3)
	
	# Check if the crown is hitting a vegetable:
	for a in $Area2D.get_overlapping_areas():
		if a.name == "Carrot" or a.name == "Pumpkin" or a.name == "Tomato" or a.name == "Radish":
			if a.hay_veg and a.name == currentTarget.name:
				a.hay_veg = false
				a.get_node("Plantado").visible = false
				a.get_node("SinPlantar").visible = true
				$SoundEffects/HitVegetable.play()


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