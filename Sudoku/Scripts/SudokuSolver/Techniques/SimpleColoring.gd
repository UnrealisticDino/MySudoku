#SimpleColoring.gd
extends Node

# Function to solve Sudoku using the Simple Coloring technique
func solve(candidates: Array) -> Array:
	#print("SimpleColoring")
	var check = candidates.duplicate(true)

	# Apply Simple Coloring technique for each number
	for num in range(1, 10):
		simple_coloring(candidates, num)

	if check != candidates:
		print("SimpleColoring used")
	return candidates

# Simple Coloring for a single number
func simple_coloring(candidates: Array, num: int):
	# Create two sets for coloring (colors can be True and False)
	var color1 = []
	var color2 = []

	# Initial coloring
	var start_cell = find_start_cell(candidates, num)
	if start_cell != Vector2(-1, -1):
		color1.append(start_cell)
		extend_coloring(candidates, num, color1, color2, start_cell)

	# Check for contradictions and eliminate candidates
	for i in range(color1.size()):
		for j in range(color2.size()):
			if color1[i].x == color2[j].x or color1[i].y == color2[j].y:
				# Contradiction found, eliminate num from these cells
				eliminate_candidate(candidates, num, color1[i])
				eliminate_candidate(candidates, num, color2[j])

# Helper functions
func find_start_cell(candidates: Array, num: int) -> Vector2:
	for row in range(9):
		for col in range(9):
			if num in candidates[row][col]:
				return Vector2(row, col)
	return Vector2(-1, -1)

func extend_coloring(candidates: Array, num: int, color1: Array, color2: Array, cell: Vector2):
	# Check if the current cell is already colored to prevent infinite recursion
	if color1.has(cell) or color2.has(cell):
		return

	# Extend coloring from the given cell
	for i in range(9):
		# Check same row and column
		var positions = [Vector2(cell.x, i), Vector2(i, cell.y)]
		for pos in positions:
			if num in candidates[pos.x][pos.y]:
				if not color1.has(pos) and not color2.has(pos):
					if cell in color1:
						color2.append(pos)
					elif cell in color2:
						color1.append(pos)
					extend_coloring(candidates, num, color1, color2, pos)

func eliminate_candidate(candidates: Array, num: int, cell: Vector2):
	if num in candidates[cell.x][cell.y]:
		candidates[cell.x][cell.y].erase(num)
