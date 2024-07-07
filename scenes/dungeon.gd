extends Node3D
@onready var log_container: VBoxContainer = %LogContainer
@onready var character_container: Node3D = %CharacterContainer
@onready var player_cam: PhantomCamera3D = %PlayerCam
@export var log_label_settings:LabelSettings
const GENERIC_CHARACTER = preload("res://scenes/generic_character.tscn")

func _ready() -> void:
	multiplayer.peer_connected.connect(player_joined)

func create_battlelog_event(msg:String):
	var l = Label.new()
	l.text = msg
	l.label_settings = log_label_settings
	create_tween().tween_callback(l.queue_free).set_delay(2.0)
	log_container.add_child(l)
	pass

# Called when the node enters the scene tree for the first time.
@rpc("any_peer","call_local")
func spawn_player(r : Game.ROLE, authority) -> void:
	create_battlelog_event("Chosen Role: %s" % Game.ROLE.keys()[Game.chosen_role])
	var c = GENERIC_CHARACTER.instantiate()
	c.character_role = r
	c.hide_all_equipment = true
	c.name = "player" + String.num(authority)
	character_container.add_child(c,false,Node.INTERNAL_MODE_BACK)
	c.set_multiplayer_authority(authority,true)
	if multiplayer.get_unique_id() == authority:
		var control = PlayerController.new()
		c.add_child(control)
		player_cam.follow_target = c
		player_cam.look_at_target = c
	pass # Replace with function body.

func player_joined(id:int):
	if Game.chosen_role != Game.STATE.NONE:
		spawn_player.rpc_id(id,Game.chosen_role,multiplayer.get_unique_id())
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_character_select_role_chosen(r: int) -> void:
	spawn_player.rpc(r,multiplayer.get_unique_id())
