extends Node2D
class_name DamagePopup

@onready var label: Label = $label

var velocity = Vector2.ZERO
var gravity = Vector2(0, -50)  # Negative for upward movement
var fade_speed = 1.5

func _ready():
	# Start slightly transparent
	modulate.a = 1.0

func init(pos: Vector2, value: String, color: Color = Color.RED):
	global_position = pos
	label.text = value
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", 32)
	
	# Random horizontal movement
	velocity = Vector2(randf_range(-30, 30), randf_range(-80, -120))

func _process(delta: float) -> void:
	# Move upward with slight horizontal drift
	position += velocity * delta
	velocity += gravity * delta
	
	# Fade out
	modulate.a -= fade_speed * delta
	
	# Remove when fully transparent
	if modulate.a <= 0:
		queue_free()
