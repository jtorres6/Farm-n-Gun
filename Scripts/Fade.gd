extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var Mat = self.get_material()
var timer
var fading_out = false
var scene

func _ready():
	Mat.set_shader_param("time",1.0)
	timer = get_node("Timer")
	timer.start()
	timer.one_shot = true
	fading_out = false
	

func _process(delta):
	if(fading_out):
		if(timer.time_left == 0):
			if(scene == "quit"):
				get_tree().quit()
			else:
				get_tree().change_scene(scene)
		else:
			Mat.set_shader_param("time",timer.wait_time-(timer.time_left)-(timer.time_left))
		
	else:
		Mat.set_shader_param("time",timer.time_left/(timer.wait_time-0.2))
	
	

func _loadScene(s):
	scene = s
	timer.start()
	fading_out=true