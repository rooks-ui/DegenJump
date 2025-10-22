extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var chest_sound: AudioStreamPlayer2D = $ChestSound

enum RewardType { MULTIPLIER_1X, MULTIPLIER_2X, MULTIPLIER_3X, MULTIPLIER_4X, MULTIPLIER_5X, TIME_BONUS }

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		chest_sound.play()
		animated_sprite_2d.animation = "openChest"
		print("Chest collected")
		# Roll for random reward
		var reward = get_random_reward()
		game_manager.open_chest(reward)
		
		get_tree().create_timer(0.47).timeout.connect(queue_free)

func get_random_reward() -> int:
	# Weighted random selection
	var random_value = randf()
	
	if random_value < 0.20:  # 20% chance
		return RewardType.MULTIPLIER_2X
	elif random_value < 0.40:  # 20% chance
		return RewardType.MULTIPLIER_3X
	elif random_value < 0.55:  # 15% chance
		return RewardType.MULTIPLIER_4X
	elif random_value < 0.68:  # 13% chance
		return RewardType.MULTIPLIER_5X
	else:  # 32% chance (most common)
		return RewardType.MULTIPLIER_1X
