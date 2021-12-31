extends Node
var birth_limit = 5
var death_limit = 4
var ca_steps = 4
var number_of_colors = 12

var red_value = 0.8
var green_value = 0.8
var blue_value = 0.8

var cmin = 0.15
var cmax = 0.8 

func _ready():
	#randomize()
	var size = Vector2(45, 45)

	
	var map = get_random_map(size)
	
	for i in 2:
		#print_map(map)
		random_walk(size, map)
	
	#print_map(map)
	
	# do cellular automata steps
	map = do_ca_steps(map)
	
	# get body color scheme
	var body_color_scheme = generate_colorscheme(number_of_colors)
	
	var eye_color_scheme = generate_colorscheme(number_of_colors)
	
	# add elements to the colors array
	for horizontal in 20:
		var vertical = VBoxContainer.new()
		$VBoxContainer/Colors/Horizontal.add_child(vertical)
		for i in number_of_colors:
			var rect = ColorRect.new()
			rect.rect_min_size = Vector2(40.0, 40.0)
			rect.color = Color(0.5, 0.5, 0.5)
			vertical.add_child(rect)
	
	# generate colors once
	update_colors()
	
	print_map(map)
	
func get_random_map(size):
	var map = []
	for x in size.x:
		map.append([])
		
	for x in range(0, ceil(size.x * 0.5)):
		var arr = []
		for y in range(0, size.y):
			arr.append(rand_bool(0.48))
			
			var to_center = (abs(y - size.y * 0.5) * 2) / size.y
			if x == floor(size.x * 0.5) - 1 || x == floor(size.x * 0.5) - 2:
				if rand_range(0.0, 0.4) > to_center:
					arr[y] = true
	
		map[x] = (arr.duplicate(true))
		map[size.x - x - 1] = (arr.duplicate(true))
		
	return map
	
func random_walk(size, map):
	var pos = Vector2(randi() % int(size.x), randi() % int(size.y))
	for i in 100:
		
		# random walk in the first half
		set_at_pos(map, pos, true)
		
		# duplicate walk on the second half, mirroring it
		set_at_pos(map, Vector2(size.x - pos.x -1, pos.y), true)
		
		# change position for the next walk
		pos += Vector2(randi() % 3 - 1, randi() % 3 - 1)

func set_at_pos(map, pos, val):
	if pos.x < 0 || pos.x >= map.size() || pos.y < 0 || pos.y >= map[pos.x].size():
		return false
	
	map[pos.x][pos.y] = val
	return true

func do_ca_steps(map):
	for i in ca_steps:
		map = step(map)
	return map

func step(map):
	var dup = map.duplicate(true)
	for x in range(0, map.size()):
		for y in range(0, map[x].size()):
			var cell = dup[x][y]
			var n = get_neighbours(map, Vector2(x, y))
			if(cell && n < death_limit):
				dup[x][y] = false
			elif !cell && n > birth_limit:
				dup[x][y] = true
	return dup

func get_neighbours(map, pos):
	var neighbour_count = 0
	
	for i in range(-1, 2):
		for j in range(-1, 2):
			if !(i == 0 && j == 0):
				if get_neighbour_value(map, pos + Vector2(i, j)):
					neighbour_count += 1
	
	return neighbour_count

func get_neighbour_value(map, pos):
	if(pos.x < 0 || pos.x >= map.size() || pos.y < 0 || pos.y >= map[pos.x].size()):
		return null
	
	return map[pos.x][pos.y]

func generate_colorscheme(number_of_colors):
	var a = Vector3(rand_range(0.0, 0.5), rand_range(0.0, 0.5), rand_range(0.0, 0.5))
	var b = Vector3(rand_range(0.1, 0.6), rand_range(0.1, 0.6), rand_range(0.1, 0.6))
	var c = Vector3(rand_range(cmin, cmax), rand_range(cmin, cmax), rand_range(cmin, cmax))
	var d = Vector3(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0))
	
	var colors = PoolColorArray()
	var n = float(number_of_colors - 1.0)
	
	for i in range(0, number_of_colors, 1):
		var color = Vector3()
		color.x = (a.x + b.x * cos(PI * 2 * (c.x * float(i / n) + d.x))) + (i / n) * red_value
		color.y = (a.y + b.y * cos(PI * 2 * (c.y * float(i / n) + d.y))) + (i / n) * green_value
		color.z = (a.z + b.z * cos(PI * 2 * (c.z * float(i / n) + d.z))) + (i / n) * blue_value
		
		colors.append(Color(color.x, color.y, color.z))

	return colors



# Helper functions

func rand_bool(chance):
	return rand_range(0.0, 1.0) > chance


func print_map(map):
	for x in map.size():
		for y in map[x].size():
			if map[y][x] == true:
				printraw(".")
			else:
				printraw(" ")
		print("")

func update_colors():
	# set colors on colormaps
	for vertical in $VBoxContainer/Colors/Horizontal.get_children():
		var colorscheme = generate_colorscheme(number_of_colors)
		
		for rect in vertical.get_children():
			rect.color = colorscheme[rect.get_index()]

func _on_RedSlider_value_changed(value):
	print(value)
	red_value = value
	update_colors()


func _on_GreenSlider_value_changed(value):
	green_value = value
	update_colors()


func _on_BlueSlider_value_changed(value):
	blue_value = value
	update_colors()


func _on_cmin_value_changed(value):
	cmin = value
	update_colors()

func _on_cmax_value_changed(value):
	cmax = value
	update_colors()
