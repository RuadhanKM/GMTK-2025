extends TileMapLayer

var hovered_tile = Vector2i(0, 0)
var drawing = false
var current_path = []
@onready var hovered_sprite = $"TileMapHoverHighlight"

# Hardcoded for current tilemap, change later
const movement_tileset_map = {
	"(0, -1)" : Vector2i(2, 0),
	"(0, 1)" : Vector2i(1, 0),
	"(-1, 0)" : Vector2i(1, 1),
	"(1, 0)" : Vector2i(2, 1),
}

func cancel_drawing():
	drawing = false
	for tile in current_path:
		set_cell(tile, 0, Vector2i(0, 1))
	current_path = []

func confirm_drawing():
	drawing = false
	
	var new_curve = Curve2D.new()
	for i in current_path:
		new_curve.add_point(to_global(map_to_local(Vector2(i))))
	new_curve.add_point(to_global(map_to_local(Vector2(current_path[0]))))
	var new_path = Path2D.new()
	new_path.curve = new_curve
	$"/root/main".add_child(new_path)
	
	GameManager.current_paths.append(new_path)
	current_path = []

func _process(delta: float) -> void:
	var new_hovered_tile = local_to_map(to_local(get_viewport().get_mouse_position()))
	var new_hovered_tile_dir = new_hovered_tile - hovered_tile
	var new_hovered_tile_data = get_cell_tile_data(new_hovered_tile)
	hovered_sprite.position = map_to_local(new_hovered_tile)
	hovered_sprite.visible = new_hovered_tile_data != null
	
	if drawing:
		if movement_tileset_map.has(str(new_hovered_tile_dir)):
			var new_tile_altas_coords = movement_tileset_map[str(new_hovered_tile_dir)]
			if new_hovered_tile_data:
				if new_hovered_tile_data.get_custom_data("Type") == "FLOOR":
					if len(current_path) == 0:
						current_path.append(hovered_tile)
						set_cell(hovered_tile, 0, new_tile_altas_coords)
					current_path.append(new_hovered_tile)
					set_cell(new_hovered_tile, 0, new_tile_altas_coords)
				elif len(current_path) > 3 && new_hovered_tile == current_path[0]:
					confirm_drawing()
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
		if event.is_pressed() and hovered_tile_data and hovered_tile_data.get_custom_data("Type") == "FLOOR":
			drawing = true
		if event.is_released():
			cancel_drawing()

func _ready() -> void:
	GameManager.grnd_layer = self
