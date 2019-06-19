extends KinematicBody2D

var velocity = Vector2()
var damage = 1000
var penetracion = true
var delay = 2

var xdirection
var ydirection 
var SPEED = 0
var Mat
var lifeTimer
func _ready():
	
	Mat = $Sprite.get_material()
	lifeTimer = get_node("LifeTimer")
	Mat.set_shader_param("time",1.0)
	lifeTimer.start()
	pass

func _process(delta):
	Mat.set_shader_param("time",lifeTimer.time_left)

func _on_LifeTimer_timeout():
	queue_free()
