extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Menu ready")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_game_button_pressed():
	var level_scene = "res://scenes/level_container.tscn"
	get_tree().change_scene_to_file(level_scene)


func _on_settings_button_pressed():
	pass
