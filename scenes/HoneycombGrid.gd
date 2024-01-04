extends TileMap

class_name HoneycombGrid

signal flag_change(number_of_flags)
signal game_lost
signal game_won

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
var cells_with_flags = []
var flags_placed = 0
var cells_checked_recursively = []
var is_game_finished = false

func _ready():
	clear_layer(DEFAULT_LAYER)
	
	for i in rows:
		for j in columns:
			var cell_coord = Vector2(i - rows / 2, j - columns / 2)
			set_tile_cell(cell_coord, "DEFAULT")
	
	place_grubs()

func _input(event: InputEvent):
	if is_game_finished:
		return
		
	if !(event is InputEventMouseButton) || event.pressed:
		return
	
	var clicked_cell_coord = local_to_map(get_local_mouse_position())
	
	if event.button_index == 1:
		on_cell_clicked(clicked_cell_coord)
	elif event.button_index == 2:
		place_flag(clicked_cell_coord)

func on_cell_clicked(cell_coord: Vector2i):
	if cells_with_grubs.any(func (cell): return cell.x == cell_coord.x && cell.y == cell_coord.y):
		lose(cell_coord)
		return
	
	if cells_with_flags.has(cell_coord):
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

func set_tile_cell(cell_coord: Vector2, cell_type: String, alt: int = 0):
	set_cell(DEFAULT_LAYER, cell_coord, TILE_SET_ID, CELLS[cell_type], alt)

func lose(cell_coord: Vector2i):
	game_lost.emit()
	is_game_finished = true
	
	for cell in cells_with_grubs:
		set_tile_cell(cell, "GRUB")
	
	set_tile_cell(cell_coord, "SMASHED")

func place_flag(cell_coord: Vector2i):
	var tile_data = get_cell_tile_data(DEFAULT_LAYER, cell_coord)
	var atlas_coords = get_cell_atlas_coords(DEFAULT_LAYER, cell_coord)
	
	var cell_has_grub = tile_data.get_custom_data("has_grub")
	var is_empty_cell = atlas_coords == Vector2i(1,3)
	var is_flag_cell = atlas_coords == Vector2i(1,2)
	
	if !is_empty_cell and !is_flag_cell:
		return
	
	if is_flag_cell:
		# doesn't this take away the has_grub?
		if cell_has_grub:
			set_tile_cell(cell_coord, "DEFAULT", 1)
		else:
			set_tile_cell(cell_coord, "DEFAULT")
		cells_with_flags.erase(cell_coord)
		flags_placed -= 1
	
	elif is_empty_cell:
		if flags_placed == number_of_grubs:
			return
		
		flags_placed += 1
		if cell_has_grub:
			set_tile_cell(cell_coord, "FLAG", 2)
		else:
			set_tile_cell(cell_coord, "FLAG")
		cells_with_flags.append(cell_coord)
	
	flag_change.emit(flags_placed)
	
	var count = 0
	for flag_cell in cells_with_flags:
		for grub_cell in cells_with_grubs:
			if flag_cell.x == grub_cell.x and flag_cell.y == grub_cell.y:
				count += 1
	
	if count == cells_with_grubs.size():
		win()
	
func win():
	is_game_finished = true
	game_won.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
