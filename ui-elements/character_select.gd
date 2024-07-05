extends Control

func advance() -> void:
	Game.transition_dungeon()
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
