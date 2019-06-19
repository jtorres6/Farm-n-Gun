extends CanvasLayer

var ready = false

func _ready():
		$Timer.start()
		
func _process(delta):
	pass


func _on_Timer_timeout():
	ready = true
	$Label.show()

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.pressed and ready:
			get_tree().change_scene("res://Scenes/MainScene.tscn")