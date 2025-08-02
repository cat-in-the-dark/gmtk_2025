extends Area2D


func _on_body_entered(body):
	if body is Player:
		print("GAME OVER")
		# TODO: gameover or restart of the room?
		get_tree().change_scene_to_file("res://game_scene.tscn")
