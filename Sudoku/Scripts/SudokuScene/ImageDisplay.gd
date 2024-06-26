#Cell
extends Sprite

# Preload the sprite sheet
var sprite_sheet = preload("res://Sudoku/DefaultSprites/numbers.png")
var white_shader = preload("res://Sudoku/DefaultSprites/white_shader.shader")
var cell_size = GameState.scaled_cell_size

# Define a dictionary to map numbers to their positions in the 3x3 grid
var number_positions = {
	1: Vector2(0, 0),
	2: Vector2(1, 0),
	3: Vector2(2, 0),
	4: Vector2(0, 1),
	5: Vector2(1, 1),
	6: Vector2(2, 1),
	7: Vector2(0, 2),
	8: Vector2(1, 2),
	9: Vector2(2, 2)
	}

# Dictionary to hold penciled digits
var penciled_sprites = {}
var player_digits = Global.player_digit_color
var game_placed_digits = Global.game_placed_digit_color
var noted_digit = Global.player_digit_color

func _ready():
	# Get the texture of the sprite sheet
	var texture = sprite_sheet.get_data()
	# Calculate and set the digit scale factor
	var texture_height = texture.get_height()
	
	GameState.digit_scale_factor = (0.80 * cell_size) / (texture_height / 2.0)

	# Apply the shader to the main sprite
	var shader_material = ShaderMaterial.new()
	shader_material.shader = white_shader
	self.material = shader_material

	# Initialize the penciled_sprites dictionary and apply the shader
	for i in range(1, 10):
		var sprite = Sprite.new()
		sprite.name = "pencil_" + str(i)
		sprite.material = shader_material.duplicate()
		add_child(sprite)
		penciled_sprites[i] = sprite

func set_number(value, source):
	# Convert the float value to an integer
	var int_value = int(value)

	if int_value in number_positions:
		if sprite_sheet:
			var cell_width = sprite_sheet.get_width() / 3
			var cell_height = sprite_sheet.get_height() / 3

			# Get the position of the number in the sprite sheet
			var position = number_positions[int_value]

			# Calculate the x and y coordinates based on the position
			var x_position = position.x * cell_width
			var y_position = position.y * cell_height

			# Set the texture and region_rect to display the correct number
			self.texture = sprite_sheet
			self.region_rect = Rect2(x_position, y_position, cell_width, cell_height)
			self.region_enabled = true
		else:
			print("Sprite sheet not loaded")

		# Set the color based on the source
		if source == "game":
			self.modulate = game_placed_digits
		elif source == "player":
			self.modulate = player_digits
	else:
		clear_cell()

func clear_overlay():
	self.region_enabled = false
	self.texture = null

func set_pencil_digit(digit, show):
	if sprite_sheet:
		var cell_width = sprite_sheet.get_width() / 3
		var cell_height = sprite_sheet.get_height() / 3

		# Get the position of the number in the sprite sheet
		var position = number_positions[digit]
		
		# Calculate the x and y coordinates based on the position
		var x_position = position.x * cell_width
		var y_position = position.y * cell_height

		var sprite = penciled_sprites[digit]
		if show:
			sprite.texture = sprite_sheet
			sprite.region_rect = Rect2(x_position, y_position, cell_width, cell_height)
			sprite.region_enabled = true

			# Adjust the scale for the penciled-in digit
			sprite.scale = Vector2(0.33, 0.33)

			# Adjust the position to center the penciled-in digit within its grid position
			var centered_x = (cell_width / 3 - sprite.texture.get_width() * sprite.scale.x) / 2
			var centered_y = (cell_height / 3 - sprite.texture.get_height() * sprite.scale.y) / 2
			var grid_x = position.x * cell_width / 3
			var grid_y = position.y * cell_height / 3
			sprite.position = Vector2(grid_x + centered_x, grid_y + centered_y)
			sprite.modulate = noted_digit

		else:
			sprite.region_enabled = false
			sprite.texture = null

func clear_cell():
	# Clear the main sprite's texture
	self.texture = null
	self.region_enabled = false

	# Clear textures from the penciled digit sprites
	for i in range(1, 10):
		if has_node("pencil_" + str(i)):
			var pencil_sprite = get_node("pencil_" + str(i))
			pencil_sprite.texture = null
			pencil_sprite.region_enabled = false

func clear_pencil_digits():
	for i in range(1, 10):
		set_pencil_digit(i, false)
