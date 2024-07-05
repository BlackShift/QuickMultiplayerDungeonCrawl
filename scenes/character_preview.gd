class_name CharacterPreview extends Node3D

@export var hide_equip:bool = true
var preview:PackedScene:
	set(value):
		preview = value
		if preview:
			character = generic_character.new()
			character.character_scene = preview
			character.hide_all_equipment = hide_equip
			character_container.add_child(character)

@export var rotation_speed:float = 2
@onready var character_container: Node3D = $CharacterContainer
var character:generic_character
var rotate_tween:Tween

func _ready() -> void:
	print("Ready! ", self)

func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		character_container.rotate(Vector3.UP,rotation_speed * delta)

