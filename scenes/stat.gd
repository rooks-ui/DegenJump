extends Label

@onready var wealth_progress_bar: TextureProgressBar = %WealthProgressBar
@onready var coins_label: Label = $"../../../CanvasLayer/CoinsPanel/CoinsLabel"
@onready var bag_label: Label = $CanvasLayer/BagPanel/BagLabel

var game_manager: Node

func _ready():
	game_manager = get_tree().get_first_node_in_group("game_manager")

func _process(delta: float) -> void:
		text = "BAG : $" + str(game_manager.bagged_coins)
