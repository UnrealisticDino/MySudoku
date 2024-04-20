#PlayerInput.gd
extends Control

var grid_cells = []
var scaled_cell_size = GameState.scaled_cell_size
var selected_cell_color = Global.selected_cell_color
var player_digit_color = Global.player_digit_color
onready var DrawGrid = get_node("../../../BackgroundColor/DrawGrid")
var selected_cells = []
var is_pencil_mode = false
var digit_scale_factor = GameState.digit_scale_factor
var use_font = GameState.use_font
var font: DynamicFont

func _ready():
	digit_scale_factor = GameState.digit_scale_factor
	digit_scale_factor = digit_scale_factor * .03
	scaled_cell_size = GameState.scaled_cell_size * 1.9

	# Access the font from the Global singleton
	font = Global.font

	# Initialize 3x3 grid with numbers 1-9
	for row in range(3):
		for col in range(3):
			var cell = Node2D.new()

			var highlight = ColorRect.new()
			highlight.rect_min_size = Vector2(scaled_cell_size, scaled_cell_size)
			highlight.color = selected_cell_color
			highlight.visible = false
			highlight.rect_position = Vector2(0, 0)
			cell.add_child(highlight)

			if use_font:
				# Create a Label with the font and color from the Global singleton
				var label = Label.new()
				label.text = str(row * 3 + col + 1)
				label.add_font_override("font", font)
				label.modulate = Global.player_digit_color  # Set the text color
				label.rect_min_size = Vector2(scaled_cell_size, scaled_cell_size)
				label.align = Label.ALIGN_CENTER
				label.valign = Label.VALIGN_CENTER
				cell.add_child(label)

				cell.position = Vector2(col * scaled_cell_size, row * scaled_cell_size)
				add_child(cell)
				grid_cells.append(cell)

			else:
				var sprite = Sprite.new()
				sprite.z_index = 1
				sprite.set_script(preload("res://Sudoku/Scripts/SudokuScene/ImageDisplay.gd"))
				sprite.call("set_number", row * 3 + col + 1, "player")
				sprite.position = Vector2(scaled_cell_size / 2, scaled_cell_size / 2)
				sprite.scale = Vector2(scaled_cell_size / 2, scaled_cell_size / 2) * digit_scale_factor
				cell.add_child(sprite)

				cell.position = Vector2(col * scaled_cell_size, row * scaled_cell_size)
				add_child(cell)
				grid_cells.append(cell)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		print("Android back button pressed")
		get_tree().change_scene("res://Scenes/StartGame.tscn")
		
func _input(event):

	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = event.position

		# Handle cell selection
		for i in range(len(grid_cells)):
			var cell = grid_cells[i]
			var cell_rect = Rect2(cell.global_position, Vector2(scaled_cell_size, scaled_cell_size))

			if cell_rect.has_point(mouse_pos):
				# Calculate the digit based on the index in the grid_cells array
				var row = i / 3  # Integer division to get the row
				var col = i % 3  # Modulo to get the column
				var digit = row * 3 + col + 1  # Calculate the digit

				if digit != null:
					selected_cells = DrawGrid.selected_cells
					for selected_cell in selected_cells:
						if is_pencil_mode:
							DrawGrid.toggle_pencil_digit(selected_cell, i+1)
						elif is_pencil_mode == false:
							DrawGrid.input_number(selected_cell, digit)
				else:
					print("Digit is null")

				selected_cells = cell
				selected_cells.get_child(0).visible = true  # Show the highlight of the selected cell

	elif selected_cells:
		selected_cells.get_child(0).visible = false  # Hide the highlight of the selected cell
		selected_cells = null

func _draw():
	# Draw grid lines
	var grid_size = 3
	var start_x = 0
	var start_y = 0
	var grid_color = Global.grid_lines_color

	# Draw white background for the grid
	var grid_area = Rect2(start_x, start_y, grid_size * scaled_cell_size, grid_size * scaled_cell_size)
	draw_rect(grid_area, Global.button_bg_color, true)

	# Draw grid lines
	for i in range(grid_size + 1):
		var start_point = Vector2(start_x + i * scaled_cell_size, start_y)
		var end_point = Vector2(start_x + i * scaled_cell_size, start_y + grid_size * scaled_cell_size)
		var line_thickness = 2 if i % 3 != 0 else 4  # Thicker lines for every 3rd line
		draw_line(start_point, end_point, grid_color, line_thickness)

		start_point = Vector2(start_x, start_y + i * scaled_cell_size)
		end_point = Vector2(start_x + grid_size * scaled_cell_size, start_y + i * scaled_cell_size)
		draw_line(start_point, end_point, grid_color, line_thickness)

func _on_Pencil_button_up():
	if is_pencil_mode:
		is_pencil_mode = false
	else:
		is_pencil_mode = true
