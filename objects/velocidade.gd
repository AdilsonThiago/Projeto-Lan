extends Area2D

var active = true

func _ready():
	pass

func _on_velocidade_body_entered(body):
	if body.is_in_group("ball") && active && body.is_network_master():
		body.subir_velocidade()
		active = false
		rpc("remover")
	pass

remotesync func remover():
	queue_free()
	pass
