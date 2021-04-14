extends CanvasLayer

onready var powerup = preload("res://objects/velocidade.tscn")
var spawn_delay = 1.0
var pontuacao = [0, 0]

func goal(sid):
	rpc("point", sid)
	pass

remotesync func point(side):
	pontuacao[side] += 1
	get_node(str("placar") + str(side + 1)).text = str(pontuacao[side])
	pass

func _process(delta):
	if is_network_master():
		spawn_delay -= delta
		if spawn_delay <= 0:
			spawn_delay = 2.0
			rpc("spawn", Vector2(rand_range(100, 924), rand_range(100, 500)))
	pass

remotesync func spawn(pos):
	var o = powerup.instance()
	get_parent().add_child(o)
	o.position = pos
	pass
