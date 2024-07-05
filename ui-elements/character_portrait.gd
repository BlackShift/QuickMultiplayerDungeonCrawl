extends Control

@onready var character_preview: CharacterPreview = $PanelContainer/MarginContainer/SubViewportContainer/SubViewport/CharacterPreview
@export var character:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if character:
		print(character.resource_path)
		character_preview.preview = character
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
