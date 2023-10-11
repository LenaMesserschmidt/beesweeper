extends TileMap

class_name HoneycombGrid

@export var rows = 8
@export var columns = 8
@export var number_of_grubs = 10

const CELLS = {
	"1": Vector2i(0,0),
	"2": Vector2i(1,0),
	"3": Vector2i(2,0),
	"4": Vector2i(0,1),
	"5": Vector2i(1,1),
	"6": Vector2i(2,1),
	"CLEAR": Vector2i(0,2),
	"FLAG": Vector2i(1,2),
	"GRUB": Vector2i(2,2),
	"SMASHED": Vector2i(0,3),
	"DEFAULT": Vector2i(1,3)
}

const TILE_SET_ID = 0
const DEFAULT_LAYER = 0

func _ready():
	clear_layer(DEFAULT_LAYER)
	
	for i in rows:
		for j in columns:
			var cell_coord = Vector2(i - rows / 2, j - columns / 2)
			set_tile_cell(cell_coord, "DEFAULT")

func set_tile_cell(cell_coord: Vector2, cell_type: String):
	set_cell(DEFAULT_LAYER, cell_coord, TILE_SET_ID, CELLS[cell_type])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
