extends StaticBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var item_scene:PackedScene
var opened = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open():
	if !animation_player.is_playing() && opened == false:
		animation_player.play(&"open_lid")
		opened = true
	pass

func close():
	if !animation_player.is_playing() && opened == true:
		animation_player.play_backwards(&"open_lid")
		opened = false
	pass
