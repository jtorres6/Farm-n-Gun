extends Area2D

# class member variables go here, for example:
# var a = 2
var inside_area
var hay_veg
var active_time
var vegetable_shield = 15

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	inside_area = false
	hay_veg = false
	active_time = false
	get_node("Plantado").visible = false
	get_node("Creciendo").visible = false
	pass

func _process(delta):
	$Label.text = str(int($Timer.time_left + 1)) + "s"
	if(inside_area and Input.is_action_just_pressed("interact")):
		if(hay_veg == true):
			get_node("Plantado").visible = false
			get_node("SinPlantar").visible = true
			$Label.visible = false
			hay_veg = false
			$ShieldUp.play()
			#AQUI CAMBIAR EL ARMAAAA Y LAS COSASSSS
			get_parent().get_node('Player').shield += vegetable_shield
			if get_parent().get_node('Player').shield > 100:
				get_parent().get_node('Player').shield = 100
			get_parent().get_node('LabelShield').text = str(get_parent().get_node('Player').shield) + "%"
		else:
			if(!active_time):
				get_node("SinPlantar").visible = false
				get_node("Creciendo").visible = true
				$Label.visible = true
				get_node("Timer").start()
				active_time = true
				get_parent().get_node("SoundEffects/Plant").play()
			
	pass


func _on_Vegetable_body_entered(body):
	if(body.name == "Player"):
		inside_area = true
	pass # replace with function body


func _on_Vegetable_body_exited(body):
	inside_area = false
	pass # replace with function body


func _on_Timer_timeout():
	get_node("Plantado").visible = true
	get_node("Creciendo").visible = false
	$Label.visible = false
	hay_veg = true
	active_time = false
	pass # replace with function body
