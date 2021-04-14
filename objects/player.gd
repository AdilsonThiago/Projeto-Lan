extends KinematicBody2D

var Velocidade = 150
var BotaoVertical = 0

func Start(side):
	$Sprite.scale.x = $Sprite.scale.x * side
	pass

func _input(event):
	if is_network_master():
		if event.is_action_pressed("botao_baixo"):
			BotaoVertical = 1
		elif event.is_action_released("botao_baixo"):
			BotaoVertical = 0
		elif event.is_action_pressed("botao_cima"):
			BotaoVertical = - 1
		elif event.is_action_released("botao_cima"):
			BotaoVertical = 0
		rpc("Atualizar_Botao", BotaoVertical)
	if get_tree().is_network_server():
		rpc_unreliable("Atualizar_Posicao", position)
	pass

remotesync func subir_velocidade():
	Velocidade += 50
	pass

remote func Atualizar_Botao(btv):
	BotaoVertical = btv
	pass

remote func Atualizar_Posicao(pos):
	position = pos
	pass

func _process(delta):
	move_and_slide(Vector2(0, Velocidade * BotaoVertical))
	pass
