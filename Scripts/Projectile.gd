extends KinematicBody2D

var velocity = Vector2()
var damage = 50
var penetracion = false
var xdirection
var ydirection 
var SPEED = 400

func _process(delta):
	var speedx = SPEED*1.2
	var speedy = SPEED
	speedx = speedx * xdirection * delta
	speedy = speedy * ydirection * delta
	
	var viewport = get_viewport_rect().size
	var posicion = position
	
	if posicion.x > viewport.x or posicion.y < -viewport.y:
		queue_free()
	
	move_and_collide(Vector2(speedx, speedy))