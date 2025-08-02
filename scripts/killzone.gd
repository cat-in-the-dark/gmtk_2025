extends Area2D

func restart_game():
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")

func _on_body_entered(body):
	if body is Player:
		print("GAME OVER")
		# TODO: gameover or restart of the room?
		call_deferred("restart_game")
