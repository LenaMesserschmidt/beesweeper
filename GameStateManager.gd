extends Node

@export var grid: HoneycombGrid
@export var ui: UI

@onready var timer = $Timer

var time_elapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	grid.cells_with_flags
	grid.game_lost.connect(on_game_lost)
	grid.game_won.connect(on_game_won)
	grid.flag_change.connect(on_flag_change)
	
	ui.set_grub_count(grid.number_of_grubs)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	time_elapsed += 1
	ui.set_timer_count(time_elapsed)

func on_game_lost():
	timer.stop()
	ui.game_lost()
	
func on_game_won():
	timer.stop()
	ui.game_won()

func on_flag_change(flags_count: int):
	ui.set_grub_count(grid.number_of_grubs - flags_count)
