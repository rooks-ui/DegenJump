extends Node

@onready var game_over: CanvasLayer = $GameOver
@onready var game_manager: Node = %GameManager
@onready var label: Label = $Timer/TimeProgressBar/Label
@onready var time_progress_bar: TextureProgressBar = $Timer/TimeProgressBar
@onready var hourglass: Area2D = $hourglass
@onready var in_game_dialogue: CanvasLayer = $InGameDialogue
@onready var wealth_progress_bar: TextureProgressBar = %WealthProgressBar

var total_time: float = 60.0
var max_time: float = 60.0


func _ready():
	add_to_group("level")
	for hourglass in get_tree().get_nodes_in_group("hourglass"):
		hourglass.collected.connect(on_hourglass)
	
	# Listen for new hourglasses being added to the scene
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	# Check if the new node is an hourglass
	if node.is_in_group("hourglass"):
		node.collected.connect(on_hourglass)

func _process(delta):
	if total_time > 0:
		total_time -= delta
		timer_update()
		check_time_warnings()
	elif total_time <= 0:
		total_time = 0
		game_over.game_over()
		set_process(false)
	
	

func on_hourglass(int):
	"""Called when player collects an hourglass item"""
	total_time += int
	print("⏰ TIME BONUS: +%d seconds! Total time: %.1f" % [int, total_time])

func timer_update():
	if time_progress_bar and total_time > 0:
		time_progress_bar.value = total_time
		label.text = str(int(total_time))
		
		# Update time progress bar color based on time remaining
		var time_percentage = total_time / max_time
		if time_percentage > 0.5:
			time_progress_bar.modulate = Color.GREEN  # Bull phase
		elif time_percentage > 0.25:
			time_progress_bar.modulate = Color.YELLOW  # Warning
		else:
			time_progress_bar.modulate = Color.RED  # Bear phase / Critical

func check_time_warnings():
	"""Alert player when time is running low"""
	if total_time <= 10 and int(total_time) % 2 == 0:
		label.add_theme_color_override("font_color", Color.RED)
	elif total_time <= 10:
		label.add_theme_color_override("font_color", Color.WHITE)

func _on_health_progress_bar_value_changed(value: float) -> void:
	if value <= 0:
		print("💀 REKT! Health depleted - Game Over!")
		game_over.game_over()


func _on_wealth_progress_bar_value_changed(value: float) -> void:
	if value == 30:
		in_game_dialogue.degen()
