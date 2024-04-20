#GameState
extends Node

var current_pointer = -1
var history_stack = []
var number_source = []
var penciled_digits = []
var player_placed_digits = []
var puzzle = []
var save_button_name = ""
var selected_cell = Vector2(-1, -1)
var selected_cells = []
var transition_source = ""
var test = 0
var scaled_cell_size: int
var digit_scale_factor
var use_font = true
var thread = Thread.new()
