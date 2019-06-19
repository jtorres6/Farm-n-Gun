extends Node2D

var raven
var whiteRaven
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
	whiteRaven = load("res://Scenes/WhiteRaven.tscn")
	
	
func generateRed(newRaven):
	newRaven.get_node('Visuals/BlueSprite').modulate = Color(1, 39/255, 63/255, 1)
	newRaven.scale.x = 0.6
	newRaven.scale.y = 0.6
	newRaven.MAX_SPEED = newRaven.MAX_SPEED * 3
	newRaven.life = newRaven.life / 2
	
func generateGreen(newRaven):
	newRaven.get_node('Visuals/BlueSprite').modulate = Color(28/255, 1, 29/255, 1)
	newRaven.scale.x = 1.6
	newRaven.scale.y = 1.6
	newRaven.MAX_SPEED = newRaven.MAX_SPEED / 2
	newRaven.life = newRaven.life * 2

func _on_Timer_timeout():
	if generar_ravens:
		for i in range(cantidad_ravens_spawn):
			contador_ravens += 1

			var newRaven = raven.instance()
			var pos = positions[randi()%6]
			newRaven.position = pos
	
			if get_parent().oleada >= 10:
				var prob = randf()
				if prob <= 0.15:
					generateRed(newRaven)
				elif 0.15 < prob and prob <= 0.20:
					generateGreen(newRaven)
				elif 0.20 < prob and prob <= 0.30:
					newRaven = whiteRaven.instance()
					newRaven.position = pos
			elif get_parent().oleada >= 8:
				var prob = randf()
				if prob <= 0.15:
					generateRed(newRaven)
				elif 0.15 < prob and prob <= 0.20:
					generateGreen(newRaven)
			elif get_parent().oleada >= 4:
				if randf() <= 0.20:
					generateRed(newRaven)

			get_parent().add_child(newRaven)