extends Node3D
@onready var log_container: VBoxContainer = %LogContainer
@onready var character_container: Node3D = %CharacterContainer
@onready var player_cam: PhantomCamera3D = %PlayerCam
@export var log_label_settings:LabelSettings
const GENERIC_CHARACTER = preload("res://scenes/generic_character.tscn")

func create_battlelog_event(msg:String):
	var l = Label.new()
	l.text = msg
	l.label_settings = log_label_settings
	create_tween().tween_callback(l.queue_free).set_delay(2.0)
	log_container.add_child(l)
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_battlelog_event("Chosen Role: %s" % Game.ROLE.keys()[Game.chosen_role])
	var c = GENERIC_CHARACTER.instantiate()
	c.character_scene = Game.role_scenes[Game.chosen_role]
	c.hide_all_equipment = true
	var control = PlayerController.new()
	c.add_child(control)
	character_container.add_child(c)
	player_cam.follow_target = c
	player_cam.look_at_target = c
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
