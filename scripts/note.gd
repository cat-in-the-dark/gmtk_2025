extends Node2D
class_name Note

@export var room: Room
@onready var sprite = $Sprite2D
@onready var area = $Area2D

func _ready():
	room.n_notes += 1

func destroy():
	area.queue_free()
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(), 0.2)
	tween.tween_callback(queue_free)

func _on_area_2d_body_entered(body):
	if not room:
		return

	if body is Player:
		body.collect_note()
		room.collect_note()
		call_deferred('destroy')
