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
var cells_checked_recursively = []

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
	
	cells_checked_recursively.append(cell_coord)
	
	handle_cells(cell_coord)

func handle_cells(cell_coord: Vector2i):
	var tile_data = get_cell_tile_data(DEFAULT_LAYER, cell_coord)
	
	# pressed outside grid
	if tile_data == null:
		return
	
	var cell_has_grub = tile_data.get_custom_data("has_grub")
	
	if cell_has_grub:
		return
	
	var grub_count = get_surrounding_cells_grub_count(cell_coord)
	
	if grub_count == 0:
		set_tile_cell(cell_coord, "CLEAR")
		var surrounding_cells = get_surrounding_cells(cell_coord)
		for cell in surrounding_cells:
			handle_surrounding_cell(cell)
	else:
		set_tile_cell(cell_coord, "%d" % grub_count)

func handle_surrounding_cell(cell_coord: Vector2i):
	if cells_checked_recursively.has(cell_coord):
		return
	
	cells_checked_recursively.append(cell_coord)
	handle_cells(cell_coord)

func get_surrounding_cells_grub_count(cell_coord: Vector2i):
	var grub_count = 0
	var surrounding_cells = get_surrounding_cells(cell_coord)
	for cell in surrounding_cells:
		var tile_data = get_cell_tile_data(DEFAULT_LAYER, cell)
		if tile_data and tile_data.get_custom_data("has_grub"):
			grub_count += 1
	
	return grub_count

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
