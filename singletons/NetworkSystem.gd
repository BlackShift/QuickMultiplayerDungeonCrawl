extends Node

signal ping_update(s:ServerInfo,p:int)
const GAME_PORT = 4350
const MAX_CLIENTS = 4
var server_ping_peer:PacketPeerUDP
var local_ping_peer:PacketPeerUDP
var ping_thread:Thread
var server_ping_thread:Thread
var ping_hosts:Array[ServerInfo]
var ping_timestamp:Dictionary = {}

var connected = 0

func _ready() -> void:
	ping_thread = Thread.new()
	server_ping_thread = Thread.new()

	pass

func _setupSignals():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func _on_peer_connected(_id: int):
	connected += 1
	pass

func _on_peer_disconnected(_id: int):
	connected -= 1
	pass

func ping_local_loop():
	while local_ping_peer:
		var p = local_ping_peer
		p.wait()
		var t = Time.get_ticks_msec()
		var packet = p.get_packet()
		var ip = p.get_packet_ip()
		if ping_timestamp.has(ip):
			var delta:int = t - ping_timestamp[p.get_packet_ip()]
			ping_timestamp[p.get_packet_ip()] = t
			##We have to match the IP to the server
			for h in ping_hosts:
				if h.get_ip(IP.TYPE_ANY) == p.get_packet_ip():
					print("Got ping response %s with %s" % [h.address,delta])
					h.last_local_ping = delta
					h.used_slots = packet.decode_var(0)
					call_thread_safe(&"_emit_update",h,delta)

#Hack to get around threading issues
func _emit_update(h,delta):
	ping_update.emit(h,delta)

func ping_server_loop():
	while server_ping_peer:
		var p = server_ping_peer
		p.wait()
		p.get_packet()
		print("Recieved Ping Packet!")
		var pingback = connected
		p.set_dest_address(p.get_packet_ip(),p.get_packet_port())
		p.put_var(pingback)
		

func query_server(server:ServerInfo):
	var peer:PacketPeerUDP
	
	if !local_ping_peer:
		peer = PacketPeerUDP.new()
		local_ping_peer = peer
	else:
		peer = local_ping_peer
	
	if !ping_hosts.has(server):
		ping_hosts.append(server)
	
	peer.set_dest_address(server.get_ip(IP.TYPE_IPV4),server.get_port()+1)
	peer.put_var(Time.get_unix_time_from_system())
	ping_timestamp[server.get_ip()] = Time.get_ticks_msec()
	print(peer.get_local_port())
	if !ping_thread.is_started():
		ping_thread.start(ping_local_loop)
	pass

func join_server(server:ServerInfo):
	print("Joing Server %s at %s" % [server.name, server.address])
	var c_peer = ENetMultiplayerPeer.new()
	c_peer.create_client(server.get_ip(IP.TYPE_IPV4),GAME_PORT)
	multiplayer.multiplayer_peer = c_peer
	_setupSignals()
	pass

func host_server():
	if server_ping_peer:
		return
	server_ping_peer = PacketPeerUDP.new()
	server_ping_peer.bind(GAME_PORT+1)
	if !server_ping_thread.is_started():
		server_ping_thread.start(ping_server_loop)
	var s_peer = ENetMultiplayerPeer.new()
	s_peer.create_server(GAME_PORT,MAX_CLIENTS)
	s_peer.set_bind_ip("192.168.4.22")
	multiplayer.multiplayer_peer = s_peer
	connected += 1
	_setupSignals()
	
	pass
