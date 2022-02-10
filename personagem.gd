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
	print("Vidas: ", quantidade_vidas)
	print("Moeda: ", coin)

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
		#var pause = Input.is_action_just_pressed("ui_cancel")
		
		
		if is_on_floor() and jump:
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
	print("Moeda: ", coin)

func _on_morre_body_entered(body):
	morte()

func _on_mata_body_entered(body):
		velocity.y += JUMP_DIE
		body.morrer()


func _on_leva_tiro_body_entered(body):
	morte()

func morte():
	if(quantidade_vidas >= 1):
		quantidade_vidas -= 1
		morreu = true
	else:
		$".".transform.origin = start_position
		print("Vidas: ", quantidade_vidas)
	#get_node(".").queue_free()


func _on_save_body_entered(body):
	checkpoint_position = $".".transform.origin
	body.salvar()


func _on_finalizar_body_entered(body):
	finalizado = true
	body.finalizar_jogo()
	
func verifica_espinho(inimigo):
	if inimigo.starts_with("spike"):
		return true
	return false


func _on_spike_attack_body_entered(body):
	morte()
