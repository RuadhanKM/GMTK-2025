extends TileMapLayer

var hovered_tile = Vector2i(0, 0)
@onready var hovered_sprite = $"TileMapHoverHighlight"

func _process(delta: float) -> void:
	hovered_tile = local_to_map(to_local(get_viewport().get_mouse_position()))
	hovered_sprite.position = map_to_local(hovered_tile)
