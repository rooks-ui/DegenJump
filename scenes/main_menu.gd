extends Control

@onready var main_buttons: VBoxContainer = $Main_buttons
@onready var option_buttons: Panel = $"option-buttons"


func _ready() -> void:
		main_buttons.visible = true
		option_buttons.visible = false



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level1.tscn")


func _on_options_pressed() -> void:
	main_buttons.visible = false
	option_buttons.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	_ready()
