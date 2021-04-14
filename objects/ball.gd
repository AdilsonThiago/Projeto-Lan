extends RigidBody2D

var delay = 0.0
var Hud = null
var NewPos = Vector2(0, 0)
var Players = [null, null]
var LastId = 0

func start(hud):
	Hud = hud
	pass

func _process(delta):
	if delay > 0:
		delay -= delta
	if is_network_master():
		rpc_unreliable("Atualizar_Informacoes", position, linear_velocity)
		if linear_velocity.x > 0:
			LastId = 0
		else:
			LastId = 1
		if position.x < 0 && delay <= 0:
			var a = deg2rad(rand_range(- 180, 180))
			var v = Vector2(cos(a), sin(a)) * 200
			linear_velocity = v
			Hud.goal(0)
			NewPos = Vector2(512, 300)
			delay = 0.5
		elif position.x > 1024 && delay <= 0:
			var a = deg2rad(rand_range(- 180, 180))
			var v = Vector2(cos(a), sin(a)) * 200
			linear_velocity = v
			Hud.goal(1)
			NewPos = Vector2(512, 300)
			delay = 0.5
	pass

func subir_velocidade():
	Players[LastId].rpc("subir_velocidade")
	pass

func mudar_jogador(pos, jog):
	Players[pos] = jog
	pass

func _integrate_forces(state):
	if NewPos.x > 0 || NewPos.y > 0:
		var xy = state.get_transform()
		xy.origin = NewPos
		state.set_transform(xy)
		NewPos = Vector2(0, 0)
	pass

remote func Atualizar_Informacoes(pos, vel):
	NewPos = pos
	linear_velocity = vel
	pass


func _on_ball_body_entered(body):
	if is_network_master() && body.is_in_group("player"):
		linear_velocity = linear_velocity * 1.2
	pass
