extends Node

var current_paths = []
var level_orders = ["Tuna Roll", "Salmon Rol", "Egg Roll"]

var main_tile_map: TileMapLayer

func open_shop():
	assert(main_tile_map)
	var chefs = main_tile_map.get_used_cells_by_id(0, Vector2i(0, 0))
	
	for i in chefs:
		pass
