extends Node2D

var line_points = [] 
var all_point_atp_idc = []
var locked = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not locked:
			var tilemap_pos = $GroundLayer.to_local(get_viewport().get_mouse_position())
			var rea_tilemap = $GroundLayer.local_to_map(tilemap_pos)
			if check_point_is_okay(rea_tilemap):
				add_point(tilemap_pos)
				generate_path_cure()
				debug_line()

func add_point(position: Vector2) -> void:
	var tile_position = $GroundLayer.local_to_map(position)
	if line_points == []:
		line_points.append(tile_position)
	else:
		var last_point: Vector2i = line_points.back()
		# Calculate intermediate points between last_point and tile_position
		var delta = tile_position - last_point
		var steps = max(abs(delta.x), abs(delta.y))
		var this_turn_old_point = []
		for i in range(1, steps + 1):
			var interp_point = last_point + Vector2i(
				int(round(delta.x * i / steps)),
				int(round(delta.y * i / steps))
			)
			this_turn_old_point.append(interp_point)
				
			line_points.append(interp_point)
			all_point_atp_idc.append(interp_point)
			this_turn_old_point.append(last_point)
			this_turn_old_point.append(position)
		for i in this_turn_old_point:
			$GroundLayer.set_cell(i,-1, Vector2i(0,1))
			
		if tile_position == line_points[0]:
			locked == true

func generate_path_cure():
	var newcurve : Curve2D = Curve2D.new()
	for i in line_points:
		newcurve.add_point($GroundLayer.to_global($GroundLayer.map_to_local(i)))
	$Path2D.curve = newcurve

func debug_line():
	var new_line := Line2D.new()
	var curve = $Path2D.curve
	for i in curve.get_point_count():
		new_line.add_point(curve.get_point_position(i))
	new_line.width = 10
	new_line.default_color = Color.RED
	get_parent().add_child(new_line)
	
func check_point_is_okay(position: Vector2i) -> bool:
	if line_points == []:
		return true
	
	var last_point: Vector2i = line_points.back()
	
	# Allow only moves that are aligned horizontally or vertically
	if last_point.x != position.x and last_point.y != position.y:
		return false
	
	var delta = position - last_point
	var steps = max(abs(delta.x), abs(delta.y))
	
	for i in range(1, steps + 1):
		var interp_point = last_point + Vector2i(
			int(round(delta.x * i / steps)),
			int(round(delta.y * i / steps))
		)
		if interp_point in all_point_atp_idc:
			# One of the intermediate points already exists in the path
			return false
	
	return true
