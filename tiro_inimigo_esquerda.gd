extends RigidBody

var VELOCITY_X = -600
var velocity = Vector3.ZERO

#func _ready():
#	set_process(true)
#	pass

func _process(delta):
	velocity.x = VELOCITY_X * delta
	add_central_force(velocity)
