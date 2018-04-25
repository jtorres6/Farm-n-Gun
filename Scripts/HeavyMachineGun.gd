extends KinematicBody2D

var velocity = Vector2()
var type = "projectile"
var damage = 20
var penetracion = true

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var xdirection
var ydirection 
var SPEED = 600
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$AnimatedSprite.animation = "fire"
	$AnimatedSprite.play()
	pass

func _process(delta):
	var speedx = SPEED*1.2
	var speedy = SPEED
	speedx = speedx * xdirection * delta
	speedy = speedy * ydirection * delta
	
	
	move_and_collide(Vector2(speedx, speedy))