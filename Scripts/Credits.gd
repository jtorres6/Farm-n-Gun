extends CanvasLayer

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		$FadeIn.show()
		$FadeIn.fade_in()
		

func _on_FadeIn_fade_finished():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
