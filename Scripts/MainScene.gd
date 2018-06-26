extends Node2D

var oleada = 1
var intercambio_oleada_pendiente = false
var pause = true

func _process(delta):
	
	var ravens = get_node("RavenManager").contador_ravens
	if ravens == 0 and intercambio_oleada_pendiente:
		oleada += 1
		$LabelOleada.text = "GET READY..."
		$IntercambioOleadaTimer.start()
		intercambio_oleada_pendiente = false
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://Scenes/Menu.tscn")

func _on_OleadaTimer_timeout():
  intercambio_oleada_pendiente = true
  get_node("RavenManager").generar_ravens = false  
  
  $RavenManager/SpawnTimer.wait_time -= $RavenManager/SpawnTimer.wait_time * 10 / 100
  if oleada % 5 == 0:
    $RavenManager.cantidad_ravens_spawn += 1

func _on_IntercambioOleadaTimer_timeout():
  $LabelOleada.text = "WAVE %d" % oleada
  if $Player.life < 100:
    $Player.life += 15
    
  if $Player.life > 100:
    $Player.life = 100
    
  $LabelHP.text = "%d%%" % $Player.life
  
  $OleadaTimer.start()
  get_node("RavenManager").generar_ravens = true

func _on_MainTheme_finished():
	$MainTheme.play()
