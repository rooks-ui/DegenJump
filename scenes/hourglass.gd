extends Area2D

signal collected(int)
@onready var game_manager: Node = %GameManager
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var time_sound: AudioStreamPlayer2D = $TimeSound

const POPUP_SCENE = preload("res://scenes/popup.tscn") 

var bob_amplitude = 10.0  # How much the collectible bobs up and down
var bob_speed = 3.0
var initial_y: float
var pulse_scale = 1.1  # How much the sprite pulses
var bob_tween: Tween
var pulse_tween: Tween
var is_collected = false
var level: Node = null


func _ready() -> void:
	add_to_group("hourglass")
	initial_y= global_position.y
	
	await get_tree().process_frame  # Wait one frame
	level = get_tree().get_first_node_in_group("level")
	if not level:
		push_error("Hourglass: Could not find level node in 'level' group!")
	
	create_bobbing_animation()
	create_pulse_animation()

func create_bobbing_animation():
	"""Create a subtle bobbing animation for the collectible"""
	bob_tween = create_tween()
	bob_tween.set_loops()
	bob_tween.tween_method(update_bob_position, 0.0, TAU, 2.0)

func update_bob_position(angle: float):
	if not is_collected:
		global_position.y = initial_y + sin(angle) * bob_amplitude

func create_pulse_animation():
	"""Create a pulsing scale effect"""
	pulse_tween = create_tween()
	pulse_tween.set_loops()
	pulse_tween.tween_property(self, "scale", Vector2.ONE * pulse_scale, 0.8)
	pulse_tween.tween_property(self, "scale", Vector2.ONE, 0.1)

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D") and not is_collected:
		time_sound.play()
		print ("Hour glass collected")
		collect(body)
		animated_sprite_2d.play("collected")
		collected.emit(6)
		show_popup("+6s", Color.ROYAL_BLUE)
		await animated_sprite_2d.animation_finished
		queue_free()

func show_popup(text: String, color: Color):
	if POPUP_SCENE:
		var popup = POPUP_SCENE.instantiate()
		level.add_child(popup)
		# Offset popup above player
		popup.init(global_position + Vector2(0, -40), text, color)
	elif not level:
		push_error("Hourglass: Level reference is null when trying to show popup!")


func collect(main_character: Player):
	if is_collected:
		return
	
	is_collected = true
	stop_animations()

func stop_animations():
	"""Properly stop all running animations"""
	if bob_tween and bob_tween.is_valid():
		bob_tween.kill()
	
	if pulse_tween and pulse_tween.is_valid():
		pulse_tween.kill()
	
	# Reset scale in case pulse animation was running
	scale = Vector2.ONE
