extends Node

@onready var wealth_progress_bar: TextureProgressBar = %WealthProgressBar
@onready var multiplier_label: Label = $"../CanvasLayer/MultiplierLabel"
@onready var coins_label: Label = $"../CanvasLayer/CoinsPanel/CoinsLabel"
@onready var time_label: Label = $"../Timer/TimeProgressBar/Label"
@onready var time_progress_bar: TextureProgressBar = $"../Timer/TimeProgressBar"
@onready var bag_label: Label = $"../CanvasLayer/BagPanel/BagLabel"
@onready var in_game_dialogue: CanvasLayer = $"../InGameDialogue"

var current_multiplier: float = 1.0
var multiplier_active_time: float = 0.0
var multiplier_duration: float = 10.0  # How long multiplier lasts in seconds
var base_amount = 1
var total_coins = 0
var time_amount = 3.0
var bagged_coins = 0
var wealth_max = 30
# Reference to level node for adding time
var level_node: Node

func _ready():
	# Get reference to level node
	add_to_group("game_manager")
	level_node = get_tree().get_first_node_in_group("level")
	if not level_node:
		print("⚠️ Level node not found on startup, will search again when needed")
	coins_label.text = str(total_coins)
	bag_label.text = str(bagged_coins)
	update_multiplier_display()

func _process(delta):
	# Count down multiplier duration
	if current_multiplier > 1.0:
		multiplier_active_time -= delta
		if multiplier_active_time <= 0:
			current_multiplier = 1.0
			update_multiplier_display()

func open_chest(reward_type: int) -> void:
	match reward_type:
		0:  # MULTIPLIER_2X
			apply_multiplier(2.0)
		1:  # MULTIPLIER_3X
			apply_multiplier(3.0)
		2:  # MULTIPLIER_4X
			apply_multiplier(4.0)
		3:  # MULTIPLIER_5X
			apply_multiplier(5.0)
		4:	#MULTIPLIER_1X
			apply_multiplier(1.0)

func apply_multiplier(multiplier_value: float) -> void:
	current_multiplier = multiplier_value
	multiplier_active_time = multiplier_duration
	update_multiplier_display()
	add_wealth_from_chest()
	print("🚀 LEVERAGE: ", multiplier_value, "X activated for ", multiplier_duration, " seconds!")

func update_multiplier_display() -> void:
	multiplier_label.text = "🔥 %dX LEVERAGE" % int(current_multiplier)
	multiplier_label.add_theme_color_override("font_color", Color.YELLOW)

func add_wealth() -> void:
	var amount_with_multiplier = int(base_amount * current_multiplier)
	wealth_progress_bar.value += amount_with_multiplier
	total_coins += amount_with_multiplier
	coins_label.text = str(total_coins)
	print("💰 Collected: $", base_amount)
	
# Modified coin collection - now uses multiplier and phase multiplier
func add_wealth_from_chest() -> void:
	var amount_with_multiplier = int(base_amount * current_multiplier)
	wealth_progress_bar.value += amount_with_multiplier
	total_coins += amount_with_multiplier
	coins_label.text = str(total_coins)
	print("💰 Collected: $", amount_with_multiplier, " (", current_multiplier, "X leverage)")

func reset_wealth_bar() -> void:
	"""Reset wealth bar to 0 after dialogue closes"""
	wealth_progress_bar.value = 0
	print("♻️ Wealth bar reset to 0")

func add_to_bag(amount: int) -> void:
	"""Add coins to the safe bag"""
	bagged_coins += amount
	bag_label.text = str(bagged_coins)
	print("💼 Total bagged: $", bagged_coins)

func dec_time(time_amoun):
	if not level_node:
		level_node = get_tree().get_first_node_in_group("level")
	
	if level_node and level_node.has_method("_process"):
		level_node.total_time -= time_amount
		print("⏱️ TIME PENALTY: -%d seconds! Total time: %.1f" % [int(time_amount), level_node.total_time])
	else:
		# Fallback: try to find level by checking parent nodes
		var current = get_parent()
		while current:
			if current.has_property("total_time"):
				current.total_time -= time_amount
				print("⏱️ TIME PENALTY: -%d seconds! Total time: %.1f" % [int(time_amount), current.total_time])
				return
			current = current.get_parent()
		print("⚠️ Warning: Could not find level node or total_time property!")

func dice(current_roll_result):
	var mult = current_roll_result
	total_coins = total_coins * mult
	coins_label.text = str(int(total_coins))

# Helper function to get current multiplier info
func get_multiplier_info() -> Dictionary:
	return {
		"multiplier": current_multiplier,
		"remaining_time": max(0.0, multiplier_active_time),
		"is_active": current_multiplier > 1.0
	}
