extends RigidBody


func _physics_process(delta):
	var velocity = 0.07
	transform.basis = Basis(Vector3(0, 1, 0), velocity) * transform.basis
	
func moeda_coletada():
	get_node(".").get_parent().get_node("som_moeda").play()
	$".".queue_free()
