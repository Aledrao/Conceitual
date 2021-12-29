extends KinematicBody

const GRAVITY = -8
const RUN_SPEEDY = 0.005
const VELOCITY_Z = 0.1

var velocity = Vector3.ZERO
var posicao_inicial
var posicao_final
var start = true
var posicao_z

func _ready():
	posicao_inicial = get_node(".").transform.origin.x
	posicao_final = posicao_inicial + 4.5
	posicao_z = get_node(".").transform.origin.z

func _process(delta):
	velocity.y += GRAVITY * delta
	velocity.z = 0
		
	if(posicao_inicial <= posicao_final and start):
		velocity.x += RUN_SPEEDY
		if(get_node(".").transform.origin.x >= posicao_final):
			velocity.x = 0
			start = false
	if(get_node(".").transform.origin.x >= posicao_inicial and !start):
		velocity.x -= RUN_SPEEDY
	if(get_node(".").transform.origin.x <= posicao_inicial and !start):
		velocity.x = 0
		start = true
		
	if posicao_z < get_node(".").transform.origin.z:
		velocity.z -= VELOCITY_Z
	if posicao_z > get_node(".").transform.origin.z:
		velocity.z += VELOCITY_Z
			
	velocity = move_and_slide(velocity, Vector3.UP)

func morrer():
	get_node(".").queue_free()
