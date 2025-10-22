extends TextureProgressBar

@onready var statl_1: Label = $GameOver/Panel/statl_1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = statl_1.stat


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
