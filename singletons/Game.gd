extends Node

enum STATE {NONE,MENU,MENU_SERVER,C_SELECT,GAME}
enum ROLE {NONE,BARBARIAN,KNIGHT,MAGE,ROGUE}
var chosen_role:ROLE = ROLE.BARBARIAN
var role_scenes:Array[PackedScene] = [
	null,
	preload("res://characters/barbarian.tscn"),
	preload("res://characters/knight.tscn"),
	preload("res://characters/mage.tscn"),
	preload("res://characters/rogue.tscn")
]
const CHARACTER_SELECT = preload("res://ui-elements/character_select.tscn")
const DUNGEON = preload("res://scenes/dungeon.tscn")
const NETWORK_MENU = preload("res://network-menu.tscn")

signal state_change(oldState:STATE,newState:STATE)
var state:STATE = STATE.NONE:
	set(value):
		var old_state:STATE = state
		state = value
		state_change.emit(old_state,state)

func transition_char_select():
	state = STATE.C_SELECT
	get_tree().change_scene_to_packed(CHARACTER_SELECT)

func transition_main_menu():
	state = STATE.MENU

func transition_server_menu():
	state = STATE.MENU_SERVER
	get_tree().change_scene_to_packed(NETWORK_MENU)

func transition_dungeon():
	state = STATE.GAME
	get_tree().change_scene_to_packed(DUNGEON)

func init_state(s:STATE):
	if state == STATE.NONE:
		state = s