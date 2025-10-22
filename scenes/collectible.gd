extends Area2D

@onready var game_manager: Node = %GameManager
@onready var coin_collect: AudioStreamPlayer2D = $CoinCollect
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_entered(body: Node2D) -> void:
	if (body.name == "CharacterBody2D"):
		coin_collect.play()
		animated_sprite_2d.play("collected")
		game_manager.add_wealth_from_chest()
		await animated_sprite_2d.animation_finished
		queue_free()
