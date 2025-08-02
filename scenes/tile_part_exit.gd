extends Area2D
class_name TilePartExit

@export var room: Room

func _on_area_exited(area):
	# we left transition zone. Copy it too if needed
	print("EXIT AREA", area)
	room.move_transition_room()

func _on_area_entered(area):
	# We enetered transition zone. Move tile 1 and tile 2 if nit all notes collected
	print("Enter area", area)
	room.move_game_rooms()
