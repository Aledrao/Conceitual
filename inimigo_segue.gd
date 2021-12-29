extends KinematicBody

const GRAVITY = -2
const VELOCITY_Z = 0.5
const RUN_SPEEDY = 2.8
const MAXIMA_TIROS = 3
const ATIRAR_ESQUERDA = "-"
const ATIRAR_DIREITA = "+"
const TEMPO_ANDANDO = 6

var velocity = Vector3.ZERO
var posicao_z
var andar = false
var atirar = false
var ir_esquerda = true
var pre_tiro_esquerda = preload("res://tiro_inimigo_esquerda.tscn")
var pre_tiro_direita = preload("res://tiro_inimigo_direita.tscn")
var quantidade_atirar = 0
var tempo_tiro = 0
var tempo_andar = 0
var tiro_vai
var vida = 4
var new_color

func _ready():
	posicao_z = get_node(".").transform.origin.z
	print("Vida monstro: ", vida)

func _process(delta):
	velocity.x = 0
	velocity.z = 0
	velocity.y += GRAVITY * delta
	
	if posicao_z < get_node(".").transform.origin.z:
		velocity.z -= VELOCITY_Z
	if posicao_z > get_node(".").transform.origin.z:
		velocity.z += VELOCITY_Z
		
	tempo_andar += delta
	if (andar and tempo_andar <= TEMPO_ANDANDO):
		atirar = false
		if ir_esquerda:
			velocity.x -= RUN_SPEEDY
		if !ir_esquerda:
			velocity.x += RUN_SPEEDY
	elif (tempo_andar > TEMPO_ANDANDO and andar):
		andar = false
		atirar = true
	elif atirar:
		andar = false
		tempo_andar = 0
		atirar = true
		atirar(delta)

	velocity = move_and_slide(velocity, Vector3.UP)

func _on_Area_body_entered(body):
	atirar = true
	quantidade_atirar = 0

func _on_ir_esquerda_body_entered(body):
	ir_esquerda = true

func _on_ir_direita_body_entered(body):
	ir_esquerda = false

func _on_parar_body_entered(body):
	andar = false

func _on_volta_andar_body_entered(body):
	andar = true
	ir_esquerda = false

func atirar(delta):
	tempo_tiro += delta
	if(quantidade_atirar <= MAXIMA_TIROS and tempo_tiro > .15):
		andar = false
		atirar = true

		var tiro
		if ir_esquerda:
			tiro = pre_tiro_esquerda.instance()
			tiro.get_node(".").transform.origin.x = tiro.get_node(".").transform.origin.x - 30 * delta
		if !ir_esquerda:
			tiro = pre_tiro_direita.instance()
			tiro.get_node(".").transform.origin.x = tiro.get_node(".").transform.origin.x + 30 * delta
		tiro.get_node(".").transform.origin = get_node(".").transform.origin
		get_node("../").add_child(tiro)
		quantidade_atirar += 1
		tempo_tiro = 0
	elif quantidade_atirar == MAXIMA_TIROS:
		quantidade_atirar = 0
		tempo_tiro = 0
		zerar_pulo()
		
func zerar_pulo():
	andar = true
	atirar = false

func morrer():
	vida -= 1
	print("Vida monstro: ", vida)	
	
	if(vida > 0):
		if(vida == 3):
			new_color = "ea19d3"
		if(vida == 2):
			new_color = "ef9405"
		if(vida == 1):
			new_color = "ffffff"
		
		var newMaterial = SpatialMaterial.new()
		newMaterial.albedo_color = Color(new_color)
		$MeshInstance.material_override = newMaterial
	if(vida <= 0):
		get_node(".").queue_free()
