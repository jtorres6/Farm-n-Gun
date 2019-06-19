extends CanvasLayer

var fade 

func _ready():
	$PlayButton.grab_focus()
	fade = get_node("Fade")

func _on_PlayButton_pressed():
	$PlayButton.disabled = true
	fade._loadScene("res://Scenes/MainScene.tscn")
	fade.fading_out = true

func _on_Exit_pressed():
	$Exit.disabled = true
	fade._loadScene("quit")
	fade.fading_out = true

func _on_Credits_pressed():
	$Credits.disabled = true
	fade._loadScene("res://Scenes/Credits.tscn")
	fade.fading_out = true

func _on_Controls_pressed():
	$Controls.disabled = true
	fade._loadScene("res://Scenes/Controls.tscn")
	fade.fading_out = true

func _on_MenuTheme_finished():
	$MenuTheme.play()
