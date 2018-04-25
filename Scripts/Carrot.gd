extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var type = 4
var ammo = 12


var inside_area
var hay_veg
var active_time

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
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	if(inside_area and Input.is_action_just_pressed("ui_down")):
		if(hay_veg == true):
			get_node("Plantado").visible = false
			get_node("SinPlantar").visible = true
			hay_veg = false
			get_parent().get_node("SoundEffects/Recolect").play()
			#AQUI CAMBIAR EL ARMAAAA Y LAS COSASSSS
			if get_parent().get_node("Player").weapon == type:
				get_parent().get_node("Player").ammo += self.ammo
			else:
				get_parent().get_node("Player").weapon = type
				get_parent().get_node("Player").ammo = self.ammo
		else:
			if(!active_time):
				get_node("SinPlantar").visible = false
				get_node("Creciendo").visible = true
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
	hay_veg = true
	active_time = false
	pass # replace with function body
