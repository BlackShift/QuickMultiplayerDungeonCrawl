extends Control

signal role_chosen(r:Game.ROLE)

func _ready() -> void:
	if Game.chosen_role != Game.ROLE.NONE:
		queue_free()

func advance() -> void:
	role_chosen.emit(Game.chosen_role)
	queue_free()
	pass

func _on_barb_pressed() -> void:
	Game.chosen_role = Game.ROLE.BARBARIAN
	advance()
	pass # Replace with function body.

func _on_knight_pressed() -> void:
	Game.chosen_role = Game.ROLE.KNIGHT
	advance()
	pass # Replace with function body.

func _on_mage_pressed() -> void:
	Game.chosen_role = Game.ROLE.MAGE
	advance()
	pass # Replace with function body.

func _on_rogue_pressed() -> void:
	Game.chosen_role = Game.ROLE.ROGUE
	advance()
	pass # Replace with function body.
