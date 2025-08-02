extends Node2D
class_name Room

const TILEMAP_CELL_SIZE = 8
var level_size = 0

@export var n_notes: int
var n_collected_notes: int = 0

# Parts contains 3 elements of the level so we can loop them 
# until player gathers all Notes.
# The last part must be always one without notes.
@onready var game_tiles: Array[TileMapLayer] = [$Parts/Tiles1, $Parts/Tiles2]
@onready var trans_tiles: TileMapLayer = $Parts/Transition


func _ready():
	for tilemap in game_tiles:
		level_size += tilemap.get_used_rect().size.x * TILEMAP_CELL_SIZE
	level_size += trans_tiles.get_used_rect().size.x * TILEMAP_CELL_SIZE
	print(level_size)
	
	#for child in get_children():
		#print(child)
		#if child is Note:
			#n_notes += 1
	#print("Notes in level: ", n_notes)

func collect_note():
	n_collected_notes += 1
	if is_notes_callected():
		print("Level is done")

func is_notes_callected():
	return n_collected_notes >= n_notes

func move_transition_room():
	if is_notes_callected():
		return
	trans_tiles.position.x = trans_tiles.position.x + level_size
	
func move_game_rooms():
	if is_notes_callected():
		return
	for tile in game_tiles:
		tile.position.x = tile.position.x + level_size
