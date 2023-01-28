extends Camera2D

var zoom_level := 1.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			position -= event.relative * zoom / 2
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == BUTTON_LEFT:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_towards(zoom_level - 1)
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_towards(zoom_level + 1)
		else:
			if event.button_index == BUTTON_LEFT:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func zoom_towards(level: float, position: Vector2 = get_viewport().get_mouse_position()) -> void:
	var old_zoom_amout := 1.0 / zoom_level
	zoom_level = clamp(level, 1.0, 8.0)
	var zoom_amount := 1.0 / zoom_level
	global_position += (position - get_viewport().size / 2.0) * (old_zoom_amout - zoom_amount)
	zoom = Vector2(zoom_amount, zoom_amount)
