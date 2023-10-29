extends CanvasLayer

class_name UI

@export var bee_scene: PackedScene

@onready var grub_count_label = %GrubCountLabel
@onready var timer_label = %TimerLabel
@onready var game_status_button = %GameStatusButton


var game_lost_button_texture = preload("res://assets/button_dead.png")
var game_won_button_texture = preload("res://assets/button_cleared.png")

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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_status_button_pressed():
	get_tree().reload_current_scene()

func game_lost():
	game_status_button.texture_normal = game_lost_button_texture

func game_won():
	game_status_button.texture_normal = game_won_button_texture


func _on_settings_button_pressed():
	print("No settings menu")


func _on_new_game_button_pressed():
	get_tree().reload_current_scene()

