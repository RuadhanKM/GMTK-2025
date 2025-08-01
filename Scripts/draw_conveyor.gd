extends TileMapLayer

var hovered_tile = Vector2i(0, 0)
var drawing = false
var current_path = []
@onready var hovered_sprite = $"TileMapHoverHighlight"

# Hardcoded for current tilemap, change later
const movement_tileset_map = {
	"(0, -1)" : Vector2i(1, 0),
	"(0, 1)" : Vector2i(2, 0),
	"(-1, 0)" : Vector2i(1, 1),
	"(1, 0)" : Vector2i(0, 1),
}

func cancel_drawing():
	drawing = false
	for tile in current_path:
		set_cell(tile, 0, Vector2i(0, 2))
	current_path = []

func confirm_drawing():
	drawing = false
	current_path = []

func _process(delta: float) -> void:
	var new_hovered_tile = local_to_map(to_local(get_viewport().get_mouse_position()))
	var new_hovered_tile_dir = new_hovered_tile - hovered_tile
	hovered_sprite.position = map_to_local(new_hovered_tile)
	
	if drawing:
		if movement_tileset_map.has(str(new_hovered_tile_dir)):
			var new_tile_altas_coords = movement_tileset_map[str(new_hovered_tile_dir)]
			var new_hovered_tile_data = get_cell_tile_data(new_hovered_tile)
			if new_hovered_tile_data:
				if new_hovered_tile_data.get_custom_data("Type") == "CHEF":
					confirm_drawing()
				elif new_hovered_tile_data.get_custom_data("Type") == "FLOOR":
					current_path.append(new_hovered_tile)
					set_cell(new_hovered_tile, 0, new_tile_altas_coords)
				else:
					cancel_drawing()
			else:
				cancel_drawing()
		elif new_hovered_tile_dir != Vector2i.ZERO:
			cancel_drawing()
	
	hovered_tile = new_hovered_tile

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var hovered_tile_data = get_cell_tile_data(hovered_tile)
		if event.is_pressed() and hovered_tile_data and hovered_tile_data.get_custom_data("Type") == "CHEF":
			drawing = true
		if event.is_released():
			cancel_drawing()
