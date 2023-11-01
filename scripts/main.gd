extends Node

@export var bee_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var menu_scene = "res://scenes/menu.tscn"
	get_tree().change_scene_to_file(menu_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("main scene")


func _on_bee_timer_timeout():
	print("Spawn bee")
	var bee = bee_scene.instantiate()
	
	var bee_spawn_location = get_node("BeePath/BeeSpawnLocation")
	bee_spawn_location.progress_ratio = randf()
	
	var direction = bee_spawn_location.rotation + PI / 2
	
	bee.position = bee_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	bee.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	bee.linear_velocity = velocity.rotated(direction)
	
	add_child(bee)
