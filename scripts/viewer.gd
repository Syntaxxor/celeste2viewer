tool
extends Node2D

const SCREEN_PALETTE = [
	Color("#00000000"),
	Color("#1D2B53"),
	Color("#7E2553"),
	Color("#008751"),
	Color("#AB5236"),
	Color("#5F574F"),
	Color("#C2C3C7"),
	Color("#FFF1E8"),
	Color("#FF004D"),
	Color("#FFA300"),
	Color("#FFEC27"),
	Color("#00E436"),
	Color("#29ADFF"),
	Color("#83769C"),
	Color("#FF77A8"),
	Color("#FFCCAA"),
]

export (Array, int) var palette = [
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
]
export var show_spritesheet = false
export (String, FILE, "*.p8") var pico8_file setget set_pico8_file

var texture: ImageTexture
var has_generated = false

func set_pico8_file(f):
	pico8_file = f
	generate()

func generate():
	for c in get_children():
		c.queue_free()
	var file = File.new()
	file.open(pico8_file, File.READ)
	var gfx_str = PoolStringArray()
	var map_str = PoolStringArray()
	while file.is_open() && !file.eof_reached():
		var line = file.get_line()
		match line:
			"__gfx__":
				for y in range(0, 128):
					line = file.get_line()
					if line.length() < 128:
						file.seek(file.get_position() - line.length() - 1)
						break
					gfx_str.push_back(line)
				
			"__map__":
				for y in range(0, 32):
					line = file.get_line()
					if line.length() < 256:
						file.seek(file.get_position() - line.length() - 1)
						break
					map_str.push_back(line)
				#tile_map.owner = self
	file.close()
	
	var image = Image.new()
	image.create(128, gfx_str.size(), false, Image.FORMAT_RGBA8)
	image.lock()
	
	for y in range(0, gfx_str.size()):
		var line = gfx_str[y]
		for x in range(0, 128):
			var c = "0x" + line[x]
			image.set_pixel(x, y, SCREEN_PALETTE[palette[c.hex_to_int()]]);
	texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	if show_spritesheet:
		var spritesheet_viewer = Sprite.new()
		spritesheet_viewer.texture = texture
		add_child(spritesheet_viewer)
		#spritesheet_viewer.owner = self
	
	
	var tile_set = TileSet.new()
	for i in range(0, 128):
		tile_set.create_tile(i)
		tile_set.tile_set_texture(i, texture)
		# 16 tiles per row, tiles are 8x8.
		var x = i % 16
		var y = i / 16
		tile_set.tile_set_region(i, Rect2(x * 8, y * 8, 8, 8))
	var tile_map = TileMap.new()
	tile_map.tile_set = tile_set
	tile_map.cell_size = Vector2(8, 8)
	for y in range(0, map_str.size()):
		var line = map_str[y]
		for x in range(0, 128):
			var t = "0x" + line.substr(x * 2 , 2)
			var index = t.hex_to_int()
			if index:
				tile_map.set_cell(x, y, index)
	if gfx_str.size() > 64:
		print("Adding extra map data.")
		for y in range(64, gfx_str.size() - 1, 2):
			var line = gfx_str[y] + gfx_str[y + 1]
			for x in range(0, 128):
				var t = "0x" + line[x * 2 + 1] + line[x * 2]
				var index = t.hex_to_int()
				if index:
					tile_map.set_cell(x, y / 2, index)
	add_child(tile_map)
	print("Finished loading Pico8 file.")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
