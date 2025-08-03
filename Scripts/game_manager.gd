extends Node

enum plate {CLEAN_DISH, DIRTY_DISH, FOOD}

var current_paths = []
var level_orders = {
	"chefs": {
		Vector2i(6, 4): ["Tuna Roll", "Salmon Roll", "Egg Roll"],
	},
	"customers": {
		Vector2i(12, 4): ["Tuna Roll", "Salmon Roll", "Egg Roll"]
	}
}


var sushi_scene = preload("res://Scenes/sushi.tscn")
var active_sushi = []

var grnd_layer: TileMapLayer

func create_sushi_orders(chef_origin):
	for order in level_orders.chefs[chef_origin]:
		var sushi_instance = sushi_scene.instantiate()
		var path_to_add: Path2D
		var path_local_chef
		for path: Path2D in current_paths:
			path_local_chef = path.to_local(grnd_layer.to_global(grnd_layer.map_to_local(chef_origin)))
			if (path_local_chef - path.curve.get_closest_point(path_local_chef)).length() < 0.01:
				path_to_add = path
				break
		if not path_to_add:
			sushi_instance.queue_free()
			return
		
		sushi_instance.progress = path_to_add.curve.get_closest_offset(path_local_chef)
		path_to_add.add_child(sushi_instance)
		active_sushi.append(sushi_instance)
		
		sushi_instance.on_plate = plate.FOOD
		sushi_instance.sushi_order = order
		
		await get_tree().create_timer(2.0).timeout

func open_shop():
	for chef in level_orders.chefs:
		create_sushi_orders(chef)
