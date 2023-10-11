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

var cells_with_grubs = []

func _ready():
	clear_layer(DEFAULT_LAYER)
	
	for i in rows:
		for j in columns:
			var cell_coord = Vector2(i - rows / 2, j - columns / 2)
			set_tile_cell(cell_coord, "DEFAULT")
	
	place_grubs()

func _input(event: InputEvent):
	if !(event is InputEventMouseButton) || event.pressed:
		return
	
	var clicked_cell_coord = local_to_map(get_local_mouse_position())
	
	if event.button_index == 1:
		on_cell_clicked(clicked_cell_coord)
	elif event.button_index == 2:
		print("PLACE FLAG")

func on_cell_clicked(cell_coord: Vector2i):
	if cells_with_grubs.any(func (cell): return cell.x == cell_coord.x && cell.y == cell_coord.y):
		print("YOU LOSE")
		return
	
	

func place_grubs():
	for i in number_of_grubs:
		var cell_coordinates = Vector2(randi_range(-rows/2, rows/2-1), randi_range(-columns/2, columns/2-1))
		
		while cells_with_grubs.has(cell_coordinates):
			cell_coordinates = Vector2(randi_range(-rows/2, rows/2-1), randi_range(-columns/2, columns/2-1))
		
		cells_with_grubs.append(cell_coordinates)
	
	for cell in cells_with_grubs:
		erase_cell(DEFAULT_LAYER, cell)
		set_cell(DEFAULT_LAYER, cell, TILE_SET_ID, CELLS.DEFAULT, 1)

func set_tile_cell(cell_coord: Vector2, cell_type: String):
	set_cell(DEFAULT_LAYER, cell_coord, TILE_SET_ID, CELLS[cell_type])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
