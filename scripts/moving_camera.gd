extends Camera2D

var zoom_level = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			position -= event.relative * zoom / 2
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == BUTTON_LEFT:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoom_level -= 1
				zoom_level = clamp(zoom_level, 1.0, 8.0)
				zoom = Vector2(1.0 / zoom_level, 1.0 / zoom_level)
			if event.button_index == BUTTON_WHEEL_UP:
				zoom_level += 1
				zoom_level = clamp(zoom_level, 0.0, 8.0)
				zoom = Vector2(1.0 / zoom_level, 1.0 / zoom_level)
		else:
			if event.button_index == BUTTON_LEFT:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
