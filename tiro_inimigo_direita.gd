extends RigidBody

var VELOCITY_X = 500
var velocity = Vector3.ZERO
var destruir

func _ready():
	destruir = get_node(".").transform.origin.x + 300
	pass

func _physics_process(delta):
	velocity.x = VELOCITY_X * delta
	add_central_force(velocity)

	if (get_node(".").transform.origin.x >= destruir):
		get_node(".").queue_free()
		
	pass
