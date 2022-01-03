extends KinematicBody

const RUN_SPEEDY = 3
const GRAVITY = -8
const JUMP_SPEEDY = 3.5
const VELOCITY_Z = 0.5
const JUMP_DIE = 3.8

var velocity = Vector3.ZERO
var coin = 0
var posicao_z

func _init():
	posicao_z = get_node(".").transform.origin.z
	print("Moeda: ", coin)

func get_input():
	velocity.x = 0
	velocity.z = 0
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var jump = Input.is_action_just_pressed("ui_up")
	
	
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
	get_node(".").queue_free()


func _on_save_body_entered(body):
	body.salvar()
