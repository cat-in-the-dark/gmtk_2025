extends Node2D
class_name Room

signal note_collected(n_notes: int, n_collected_notes: int)

const TILEMAP_CELL_SIZE = 8
var level_size = 0

@export var next_level_prefab: PackedScene
@export var n_notes: int
var n_collected_notes: int = 0

signal level_looped(n_loops)
var loops = 0

# Parts contains 3 elements of the level so we can loop them 
# until player gathers all Notes.
# The last part must be always one without notes.
@onready var game_tiles: Array[TileMapLayer] = [$Parts/Tiles1, $Parts/Tiles2]
@onready var trans_tiles: TileMapLayer = $Parts/Transition


func _ready():
	for tilemap in game_tiles:
		level_size += tilemap.get_used_rect().size.x * TILEMAP_CELL_SIZE
	level_size += trans_tiles.get_used_rect().size.x * TILEMAP_CELL_SIZE

func collect_note():
	n_collected_notes += 1
	note_collected.emit(n_notes, n_collected_notes)

func is_notes_callected():
	return n_collected_notes >= n_notes
	
func on_level_looped():
	loops += 1
	print("Level looped: ", loops)
	level_looped.emit(loops)

func move_transition_room():
	if is_notes_callected():
		queue_free()
		return
	trans_tiles.position.x = trans_tiles.position.x + level_size
	
func spawn_next_room():
	print("spawn next room ", next_level_prefab)
	var next_level = next_level_prefab.instantiate()
	next_level.global_position = trans_tiles.global_position
	next_level.global_position.x += trans_tiles.get_used_rect().size.x * TILEMAP_CELL_SIZE
	get_tree().root.add_child(next_level)
	
func show_win_screen():
	# TODO: go to win screen
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
	
func move_game_rooms():
	if is_notes_callected():
		if next_level_prefab:
			call_deferred("spawn_next_room")
		else:
			call_deferred("show_win_screen")
	else:
		on_level_looped()
		for tile in game_tiles:
			tile.position.x = tile.position.x + level_size
