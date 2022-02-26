extends KinematicBody

const RUN_SPEEDY = 3
const GRAVITY = -8
const JUMP_SPEEDY = 3.5
const VELOCITY_Z = 0.5
const JUMP_DIE = 3.8

var velocity = Vector3.ZERO
var coin = 0
var posicao_z
var finalizado = false
var checkpoint_position
var quantidade_vidas = 3
var start_position
var morreu = false

func _init():
	posicao_z = get_node(".").transform.origin.z
	checkpoint_position = $".".transform.origin
	start_position = checkpoint_position

func get_input():
	if morreu:
		$".".transform.origin = checkpoint_position
		morreu = false
	velocity.x = 0
	velocity.z = 0
	if !finalizado:
		var right = Input.is_action_pressed("ui_right")
		var left = Input.is_action_pressed("ui_left")
		var jump = Input.is_action_just_pressed("ui_up")		
		
		if is_on_floor() and jump:
			get_node(".").get_parent().get_node("som_pulo").play()
			velocity.y = JUMP_SPEEDY
		if right:
			velocity.x += RUN_SPEEDY
		if left:
			velocity.x -= RUN_SPEEDY
		
		if posicao_z < get_node(".").transform.origin.z:
			velocity.z -= VELOCITY_Z
		if posicao_z > get_node(".").transform.origin.z:
			velocity.z += VELOCITY_Z
		
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	get_input()
	velocity = move_and_slide(velocity, Vector3.UP)
	get_node(".").get_parent().get_node("CanvasLayer").get_node("life").set_text(str(quantidade_vidas))
	get_node(".").get_parent().get_node("CanvasLayer").get_node("coins").set_text(str(coin))

func _on_pega_moeda_body_entered(body):
	body.moeda_coletada()
	coin += 1

func _on_morre_body_entered(body):
	morte()

func _on_mata_body_entered(body):
	get_node(".").get_parent().get_node("som_mata_bicho").play()
	velocity.y += JUMP_DIE
	body.morrer()


func _on_leva_tiro_body_entered(body):
	morte()

func morte():
	if(quantidade_vidas >= 1):
		get_node(".").get_parent().get_node("som_pancada").play()
		quantidade_vidas -= 1
		morreu = true
	else:
		get_node(".").get_parent().get_node("som_morte").play()
		$".".transform.origin = start_position
		get_tree().reload_current_scene()


func _on_save_body_entered(body):
	get_node(".").get_parent().get_node("som_checkpoint").play()
	checkpoint_position = $".".transform.origin
	body.salvar()


func _on_finalizar_body_entered(body):
	get_node(".").get_parent().get_node("som_principal").stop()
	get_node(".").get_parent().get_node("som_finalizado").play()
	finalizado = true
	body.finalizar_jogo()
	
func verifica_espinho(inimigo):
	if inimigo.starts_with("spike"):
		return true
	return false


func _on_spike_attack_body_entered(body):
	morte()
