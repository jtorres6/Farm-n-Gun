extends Node2D

var player
var visuals
var facing
var old_facing 

func _ready():
	player = get_parent()
	visuals = player.get_node("Visuals")

func _process(delta):
	var dir = player.facing_direction
	
	facing = dir
	if old_facing != facing and facing != 0:
		visuals.set_scale(Vector2(facing, 1))
		old_facing = facing

