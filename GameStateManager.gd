extends Node

@export var grid: HoneycombGrid
@export var ui: UI
@export var bee_scene: PackedScene

@onready var timer = $Timer
@onready var bee_timer = %BeeTimer


var time_elapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	grid.cells_with_flags
	grid.game_lost.connect(on_game_lost)
	grid.game_won.connect(on_game_won)
	grid.flag_change.connect(on_flag_change)
	
	ui.set_grub_count(grid.number_of_grubs)
	
	bee_timer.start()


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


func _on_bee_timer_timeout():
	# Create a new instance of the Mob scene.
	var bee = bee_scene.instantiate()
	
	# Choose a random location on Path2D.
	var bee_spawn_location = get_node("BeePath/BeeSpawnLocation")
	bee_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = bee_spawn_location.rotation + PI / 2
	
	# Set the mob's position to a random location.
	bee.position = bee_spawn_location.position
	
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	bee.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	bee.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene.
	add_child(bee)

