extends PanelContainer


@export var saved_servers:Array[ServerInfo]:
	set(value):
		saved_servers = value
		server_list_changed()

@onready var server_item_list: ItemList = %ServerList

@onready var server_info_panel: VBoxContainer = %ServerInfoPanel
@onready var server_name: Label = %Name
@onready var address: Label = %Address
@onready var players: Label = %Players
@onready var ping: Label = %Ping

@onready var input_name: LineEdit = %InputName
@onready var input_address: LineEdit = %InputAddress
@onready var add_server: Button = %AddServer
@onready var join: Button = %Join


var selected_server:int = -1

func server_list_changed() -> void:
	if !is_node_ready():
		server_list_changed.call_deferred()
		return
	server_item_list.clear()
	#server_info_panel.visible = false
	for server in saved_servers:
		server_item_list.add_item(server.name)
	pass


func _on_server_list_item_selected(index: int) -> void:
	if index >= saved_servers.size():
		return
	selected_server = index
	server_name.text = saved_servers[selected_server].name
	address.text = saved_servers[selected_server].address
	players.text = String.num(saved_servers[selected_server].used_slots)
	ping.text = String.num(saved_servers[selected_server].last_local_ping)
	server_info_panel.visible = true
	join.disabled = false
	NetworkSystem.query_server(saved_servers[selected_server])


func _on_join_pressed() -> void:
	var destination_server := saved_servers[selected_server]
	if !destination_server:
		return
	NetworkSystem.join_server(destination_server)
	pass # Replace with function body.

func _validate_server_input() -> void:
	if input_address.text.split(":").size() == 2:
		add_server.disabled = false
	else:
		add_server.disabled = true
		return
	
	if input_name.text.is_empty():
		add_server.disabled = true
		return
	else:
		add_server.disabled = false
	pass
	

func _on_add_server_pressed() -> void:
	_validate_server_input()
	if add_server.disabled:
		return
	
	var new_server := ServerInfo.new()
	new_server.address = input_address.text
	new_server.name = input_name.text
	saved_servers.append(new_server)
	
	input_address.clear()
	input_name.clear()
	
	server_list_changed()
	pass # Replace with function body.

func _ready() -> void:
	NetworkSystem.ping_update.connect(_on_ping_update)
	Game.init_state(Game.STATE.MENU_SERVER)
	pass

func _on_ping_update(s:ServerInfo,ping_time:int) -> void:
	var res = saved_servers.find(s)
	if res == -1:
		return
	if selected_server == res:
		ping.text = String.num(ping_time)

func _on_host_pressed() -> void:
	NetworkSystem.host_server()
	Game.transition_char_select()
	pass # Replace with function body.


func _on_delete_pressed() -> void:
	if selected_server == -1:
		return
	saved_servers.remove_at(selected_server)
	server_name.text = "No Server Selected"
	address.text = ""
	players.text = ""
	ping.text = ""
	
	selected_server = -1
	server_list_changed()
	pass # Replace with function body.
