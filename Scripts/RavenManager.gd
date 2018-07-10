extends Node2D

var raven
var contador_ravens = 0
var cantidad_ravens_spawn = 2
var generar_ravens = true
var positions = [Vector2(-120,120), 
				 Vector2(-120,-120), 
				 Vector2(320,-120), 
				 Vector2(640,-120), 
				 Vector2(1320,-120), 
				 Vector2(1320,120)]

func _ready():
	set_process(true)
	raven = load("res://Scenes/Raven.tscn")
	pass

func _on_Timer_timeout():
	"""
	if generar_ravens:
		for i in range(cantidad_ravens_spawn):
			contador_ravens += 1
			var newRaven = raven.instance()
			newRaven.position = positions[randi()%6]
			get_parent().add_child(newRaven)
	"""
	pass
