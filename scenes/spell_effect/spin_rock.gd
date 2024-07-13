extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var procession:float = randf_range(-PI,PI)
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D

static var excluded:Array[String] = []

var chosen_rock_multimesh:MultiMeshInstance3D
var chosen_rock_index = -1
var yank_tween:Tween

var chosen_transform:Transform3D:
	set(value):
		chosen_transform = value
		chosen_rock_multimesh.multimesh.set_instance_transform(chosen_rock_index,value)
	get:
		return chosen_rock_multimesh.multimesh.get_instance_transform(chosen_rock_index)
var starting_transform:Transform3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rocks_collection = get_tree().get_nodes_in_group(&"rocks_multi")
	
	
	##find a random rock in the level
	var iterations_left = 10
	while chosen_rock_index == -1 and iterations_left:
		var mm:MultiMeshInstance3D = rocks_collection.pick_random()
		var test = range(mm.multimesh.instance_count).pick_random()
		if excluded.has(String.num(test)+mm.name):
			iterations_left -= 1
			continue
		chosen_rock_multimesh = mm
		chosen_rock_index = test
		excluded.append(String.num(test)+mm.name)
	
	if chosen_rock_index == -1:
		queue_free()
		return
	yank_tween = create_tween()
	yank_tween.set_ease(Tween.EASE_IN_OUT)
	yank_tween.tween_method(_yank_tween_cb,0.0,1.0,1)
	yank_tween.finished.connect(on_yank_complete)
	starting_transform = chosen_transform
	pass # Replace with function body.

func _yank_tween_cb(lerps:float):
	var new_transform:Transform3D
	##new_transform.basis = lerp(starting_transform.basis,path_follow_3d.global_transform.basis,lerps)
	new_transform.origin = lerp(starting_transform.origin,path_follow_3d.global_transform.origin,lerps)
	chosen_transform = new_transform
	
func on_yank_complete():
	yank_tween.kill()
	yank_tween = null
	animation_player.play("spin_hula")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !yank_tween:
		rotate_y(procession * delta)
		chosen_transform = path_follow_3d.global_transform
	pass
