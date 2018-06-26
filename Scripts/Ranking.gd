extends Node2D

var fade

func _ready():
	fade = get_node("Fade")
	
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Scenes/Menu.tscn")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Main_Menu_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_Play_Again_pressed():
	fade._loadScene("res://Scenes/MainScene.tscn")
	fade.fading_out = true
