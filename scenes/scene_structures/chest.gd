extends StaticBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var item_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open():
	animation_player.play(&"open_lid")
	pass

func close():
	animation_player.play_backwards(&"open_lid")
	pass
