extends Node2D
class_name Note

@export var room: Room

func _on_area_2d_body_entered(body):
	if body is Player:
		body.collect_note()
		room.collect_note()
		queue_free()
