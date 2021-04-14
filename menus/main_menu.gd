extends Control

onready var Stage = preload("res://stages/Stage.tscn")
onready var Ball = preload("res://objects/ball.tscn")
onready var Player = preload("res://objects/player.tscn")

func _ready():
	Networking.Menu = self
	$ip.text = "127.0.0.1"
	$nome.text = "Jogador 1"
	pass

func _on_criar_button_down():
	Networking.Mudar_Ip($ip.text)
	Networking.Mudar_Nome($nome.text)
	Networking.Criar()
	
	$criar.disabled = true
	$entrar.disabled = true
	$ipshow.text = "Endereço para se conectar com\num amigo " + str(Networking.Pegar_Endereco_Ip())
	pass


func _on_entrar_button_down():
	Networking.Mudar_Ip($ip.text)
	Networking.Mudar_Nome($nome.text)
	Networking.Entrar()
	
	$criar.disabled = true
	$entrar.disabled = true
	pass

func Atualizar_Lista_Jogadores():
	var Lista = Networking.Pegar_Lista_Jogadores()
	var Id = Networking.Pegar_Identificador()
	var Num = Networking.Pegar_Numero_Jogadores()
	$jogadoreslista.clear()
	for i in range(Num):
		if Lista[i][0] == Id:
			$jogadoreslista.add_item(str(Lista[i][1]) + str(" (você)"))
		else:
			$jogadoreslista.add_item(Lista[i][1])
	pass


func _on_comecar_button_down():
	rpc("Comecar_Jogo")
	pass

remotesync func Comecar_Jogo():
	var stg = Stage.instance()
	var b = Ball.instance()
	var o = null
	var Lista = Networking.Pegar_Lista_Jogadores()
	get_parent().call_deferred("add_child", stg)
	stg.call_deferred("add_child", b)
	stg.set_network_master(Lista[0][0])
	b.position = Vector2(512, 300)
	b.set_network_master(Lista[0][0])
	b.start(stg.get_node("hud"))
	if get_tree().is_network_server():
		var angulo = deg2rad(rand_range(- 180, 180))
		var veloci = Vector2(cos(angulo), sin(angulo)) * 200
		b.linear_velocity = veloci
	
	o = Player.instance()
	o.Start(1)
	stg.call_deferred("add_child", o)
	o.position = Vector2(40, 300)
	o.set_network_master(Lista[0][0])
	b.mudar_jogador(0, o)
	
	o = Player.instance()
	o.Start(- 1)
	stg.call_deferred("add_child", o)
	o.position = Vector2(1024 - 40, 300)
	o.set_network_master(Lista[1][0])
	b.mudar_jogador(1, o)
	
	Networking.Menu = null
	queue_free()
	pass
