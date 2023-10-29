extends HBoxContainer

class_name LevelUI

@onready var grub_count_label = %GrubCountLabel
@onready var timer_label = %TimerLabel
#@onready var game_status_button = %GameStatusButton

func set_grub_count(grub_count: int):
	var grub_count_string = str(grub_count)
	if grub_count_string.length() < 3:
		grub_count_string = grub_count_string.lpad(3, "0")
	
	grub_count_label.text = grub_count_string

func set_timer_count(timer_count: int):
	var timer_string = str(timer_count)
	if timer_string.length() < 3:
		timer_string = timer_string.lpad(3, "0")
	
	timer_label.text = timer_string

func game_won():
	pass

func game_lost():
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_menu_button_pressed():
	var menu_scene = "res://scenes/menu.tscn"
	get_tree().change_scene_to_file(menu_scene)
