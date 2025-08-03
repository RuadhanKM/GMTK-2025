extends PathFollow2D

var on_plate = GameManager.plate.CLEAN_DISH
var sushi_order = ""

func _process(delta: float) -> void:
	progress += delta * 100
	
	for customer in GameManager.level_orders.customers:
		var customer_pos = GameManager.grnd_layer.to_global(GameManager.grnd_layer.map_to_local(customer))
		if (global_position - customer_pos).length() < 5 and sushi_order in GameManager.level_orders.customers[customer]:
			print("customer ate ", sushi_order)
			on_plate = GameManager.plate.DIRTY_DISH
			sushi_order = ""
	
	for chef in GameManager.level_orders.chefs:
		var chef_pos = GameManager.grnd_layer.to_global(GameManager.grnd_layer.map_to_local(chef))
		if (global_position - chef_pos).length() < 5 and on_plate == GameManager.plate.DIRTY_DISH:
			queue_free()
