extends Node

@onready var game_over: CanvasLayer = $GameOver
@onready var game_manager: Node = %GameManager

func _ready():
	add_to_group("level")

func _on_timer_timeout() -> void:
	game_over.game_over()
	

func _on_health_progress_bar_value_changed(value: float) -> void:
	if (value == 0):
			game_over.game_over()
