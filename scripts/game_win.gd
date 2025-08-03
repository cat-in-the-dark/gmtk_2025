extends Node2D

func _ready():
	$restarts.text = "LOOPS USED: %d" % Globals.n_restarts 

func restart_game():
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")

func _process(delta):
	if Input.is_action_just_pressed("player_jump"):
		call_deferred("restart_game")
