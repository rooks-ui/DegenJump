extends CanvasLayer


func _ready() -> void:
	self.hide()
	

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_backmenu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func game_over():
	get_tree().paused = true
	self.show()
