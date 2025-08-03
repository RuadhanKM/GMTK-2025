extends Control

@onready var open_button = $"OpenButton"
@onready var MenuLabel = $"MenuLabel"

func _ready() -> void:
	MenuLabel.text = "\n".join(PackedStringArray(GameManager.level_orders))

func _on_open_button_pressed() -> void:
	GameManager.open_shop()
