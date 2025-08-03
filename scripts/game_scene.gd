extends Node2D
class_name GameScene

@onready var loops_counter = $HUD/loops_counter
@onready var notes_counter = $HUD/notes_counter

func _ready():
	Globals.reset()
	
func restart_game():
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")

func _process(delta):
	if Globals.n_notest == 0:
		notes_counter.text = ""
	else: 
		notes_counter.text = "NOTES: %d" % Globals.n_notest

	if Globals.n_restarts == 0:
		loops_counter.text = ""
	else:
		loops_counter.text = "LOOPS: %d" % Globals.n_restarts

	if Input.is_action_just_pressed("restart"):
		call_deferred('restart_game')
