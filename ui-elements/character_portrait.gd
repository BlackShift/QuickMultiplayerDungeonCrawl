extends Control

@onready var character_preview: CharacterPreview = $PanelContainer/MarginContainer/SubViewportContainer/SubViewport/CharacterPreview
@export var character:Game.ROLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if character:
		character_preview.preview = character
	pass # Replace with function body.
