extends CanvasLayer

@onready var dice_sprite_2d: AnimatedSprite2D = $DialoguePanel/RiskButton/AnimatedSprite2D
@onready var safe_sprite_2d: AnimatedSprite2D = $DialoguePanel/AnimatedSprite2D
@onready var risk_button: Button = $DialoguePanel/RiskButton
@onready var game_manager: Node = %GameManager
@onready var safe_25_button: Button = $DialoguePanel/safe25Button
@onready var safe_50_button: Button = $DialoguePanel/safe50Button2
@onready var safe_75_button: Button = $DialoguePanel/safe75Button3
@onready var result_label: Label = $DialoguePanel/ResultLabel

var multiplier_outcomes = [
	# LOSSES (40% total)
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,  # 10x = 20%
	0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3,              # 8x = 16%
	0.1, 0.1,                                            # 2x = 4%
	
	# SAFE WINS (35% total)
	1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,  # 10x = 20%
	2.0, 2.0, 2.0, 2.0, 2.0, 2.0,                       # 6x = 12%
	3.0, 3.0,                                            # 2x = 4%
	
	# MEDIUM WINS (17% total)
	4.0, 4.0, 4.0,     # 3x = 6%
	5.0,          # 2x = 4%
	6.0,          # 2x = 4%
	7.0,               # 1x = 2%
	
	# BIG WINS (7% total)
	8.0,               # 1x = 2%
	9.0,               # 1x = 2%
	10.0, 10.0,        # 2x = 4%
	
	# JACKPOT (1%)
	100.0              # 1x = 2%
]
# Total: 50 items for cleaner percentages


var current_roll_result: float = 0.0
var dialogue_active: bool = false

func _ready() -> void:
	self.hide()
	result_label.hide()
	risk_button.pressed.connect(_on_risk_button_pressed)
	safe_25_button.pressed.connect(_on_safe_25_button_pressed)
	safe_50_button.pressed.connect(_on_safe_50_button_2_pressed)
	safe_75_button.pressed.connect(_on_safe_75_button_3_pressed)

func degen():
	get_tree().paused = true
	self.show()
	dialogue_active = true
	enable_all_buttons()

func _on_risk_button_pressed() -> void:
	if not dialogue_active:
		return
	
	disable_all_buttons()
	dice_sprite_2d.play("rolling")
	await dice_sprite_2d.animation_finished
	
	# Roll the dice
	current_roll_result = multiplier_outcomes[randi() % multiplier_outcomes.size()]
	print("🎲 DICE ROLL RESULT: ", current_roll_result, "X")
	
	# Apply the multiplier
	game_manager.dice(current_roll_result)
	result_label.show()
	result_label.text = 'X' + str(current_roll_result)
	result_label.add_theme_font_size_override("font_size", 28)
	if current_roll_result >= 1.0:
		result_label.add_theme_color_override("font_color", Color.YELLOW)
	elif current_roll_result < 1.0:
		result_label.add_theme_color_override("font_color", Color.RED)
	elif current_roll_result > 2.0:
		result_label.add_theme_color_override("font_color", Color.GREEN)
	
	# Close dialogue after a short delay
	await get_tree().create_timer(1.0).timeout
	result_label.hide()
	close_dialogue()

func _on_safe_25_button_pressed() -> void:
	if not dialogue_active:
		return
	
	disable_all_buttons()
	safe_sprite_2d.play("bagged")
	await safe_sprite_2d.animation_finished
	
	# Calculate 25% of total coins and add to bag
	var amount_to_bag = int(game_manager.total_coins * 0.25)
	game_manager.add_to_bag(amount_to_bag)
	game_manager.total_coins -= amount_to_bag
	
	result_label.show()
	result_label.text = '$' + str(amount_to_bag) + ' WITHDRAWN'
	result_label.add_theme_font_size_override("font_size", 20)
	result_label.add_theme_color_override("font_color", Color.GREEN)
	print("💼 BAGGED 25%: $", amount_to_bag)
	
	await get_tree().create_timer(1.2).timeout
	result_label.hide()
	close_dialogue()

func _on_safe_50_button_2_pressed() -> void:
	if not dialogue_active:
		return
	
	disable_all_buttons()
	safe_sprite_2d.play("bagged")
	await safe_sprite_2d.animation_finished
	
	# Calculate 50% of total coins and add to bag
	var amount_to_bag = int(game_manager.total_coins * 0.50)
	game_manager.add_to_bag(amount_to_bag)
	game_manager.total_coins -= amount_to_bag
	result_label.show()
	result_label.text = '$' + str(amount_to_bag) + ' WITHDRAWN'
	result_label.add_theme_font_size_override("font_size", 20)
	result_label.add_theme_color_override("font_color", Color.GREEN)
	
	print("💼 BAGGED 50%: $", amount_to_bag)
	await get_tree().create_timer(1.2).timeout
	result_label.hide()
	close_dialogue()

func _on_safe_75_button_3_pressed() -> void:
	if not dialogue_active:
		return
	
	disable_all_buttons()
	safe_sprite_2d.play("bagged")
	await safe_sprite_2d.animation_finished
	
	# Calculate 75% of total coins and add to bag
	var amount_to_bag = int(game_manager.total_coins * 0.75)
	game_manager.add_to_bag(amount_to_bag)
	game_manager.total_coins -= amount_to_bag
	result_label.show()
	result_label.text = '$' + str(amount_to_bag) + ' WITHDRAWN'
	result_label.add_theme_font_size_override("font_size", 20)
	result_label.add_theme_color_override("font_color", Color.GREEN)
	
	print("💼 BAGGED 75%: $", amount_to_bag)
	await get_tree().create_timer(1.2).timeout
	result_label.hide()
	close_dialogue()

func disable_all_buttons() -> void:
	risk_button.disabled = true
	safe_25_button.disabled = true
	safe_50_button.disabled = true
	safe_75_button.disabled = true

func enable_all_buttons() -> void:
	risk_button.disabled = false
	safe_25_button.disabled = false
	safe_50_button.disabled = false
	safe_75_button.disabled = false

func close_dialogue() -> void:
	dialogue_active = false
	self.hide()
	get_tree().paused = false
	
	# Reset wealth progress bar to 0
	game_manager.reset_wealth_bar()
	
	# Clear total coins for next cycle
	#game_manager.total_coins = 0
	#game_manager.coins_label.text = game_manager.total_coins
	print("♻️ CYCLE RESET: Wealth bar cleared")
