class_name generic_character extends CharacterBody3D

@export var character_scene:PackedScene
var character:Node3D

#Dictionary mapping of animations to play, takes stringname of animation name
@export var animation_mapping:Dictionary = {
	STATE.NULL: &"T-Pose",
	STATE.IDLE: &"Idle",
	STATE.WALK: &"Walking_A",
	STATE.RUN: &"Running_A",
}
@export var hide_all_equipment = false
@export var equipment_filters:Array[String] = []
enum STATE {NULL,IDLE,IDLE_DOWN,WALK,RUN}
var state:STATE = STATE.NULL
signal state_changed(oldState:STATE,newState:STATE)

var animPlayer:AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	character = character_scene.instantiate() as Node3D
	add_child(character)
	if hide_all_equipment:
		hide_equipment()
	#Find an animation player and hook up states
	var animation_canditates := character.find_children("*","AnimationPlayer")
	assert(animation_canditates.size() == 1,"Missing or duplicate AnimationPlayer in character scene")
	animPlayer = animation_canditates[0] as AnimationPlayer
	animPlayer.animation_finished.connect(_on_animation_finished.unbind(1))
	change_state(STATE.IDLE)

func hide_equipment():
	for b:BoneAttachment3D in character.find_children("*","BoneAttachment3D"):
		b.visible = false

func _process(_delta: float) -> void:
	match state:
		STATE.IDLE:
			if velocity.length()/SPEED > 0.1:
				change_state(STATE.WALK) 
			pass
		STATE.WALK:
			if velocity.length()/SPEED > 0.5:
				change_state(STATE.RUN)
			if velocity.length()/SPEED < 0.1:
				change_state(STATE.IDLE)
		STATE.RUN:
			if velocity.length()/SPEED < 0.5:
				change_state(STATE.WALK)
			pass
	pass

func _on_animation_finished():
	if animation_mapping.has(state):
		animPlayer.play(animation_mapping[state])

func change_state(newState:STATE):
	if animation_mapping.has(newState):
		animPlayer.play(animation_mapping[newState])
	var old_state = state
	state = newState
	animPlayer.play(animation_mapping[state])
	state_changed.emit(old_state,newState)
	pass
