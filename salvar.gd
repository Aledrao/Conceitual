extends RigidBody

var save = false

func salvar():
	if(!save):
		get_node(".").get_parent().get_node("AnimationPlayer").play("salvar")
		save = true
