extends Control

var not_pause = true

func _process(delta):
	pausar()

func pausar():
	if Input.is_action_just_pressed("ui_cancel"):
		if not_pause:
			get_tree().paused = true
			not_pause = false
			$".".visible = true
		else:
			despausar()
			
func despausar():
	get_tree().paused = false
	not_pause = true
	$".".visible = false

func _on_button_continuar_pressed():
	despausar()


func _on_button_reiniciar_pressed():
	get_tree().reload_current_scene()
	despausar()


func _on_button_sair_pressed():
	get_tree().quit()
