extends Node2D
var birth_limit = 5
var death_limit = 4
var ca_steps = 4
var number_of_colors = 12

var red_value = 0.8
var green_value = 0.8
var blue_value = 0.8
var cmin = 0.15
var cmax = 0.8 

var noise
var noise2

func _ready():
	init_noise()
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
	
	var all_groups = fill_colors(map, body_color_scheme, eye_color_scheme, number_of_colors, true)
	
	var group = draw_monster(all_groups)
	 
	# add elements to the colors array
	#for horizontal in 20:
	#	var vertical = VBoxContainer.new()
	#	$VBoxContainer/Colors/Horizontal.add_child(vertical)
	#	for i in number_of_colors:
	#		var rect = ColorRect.new()
	#		rect.rect_min_size = Vector2(40.0, 40.0)
	#		rect.color = Color(0.5, 0.5, 0.5)
	#		vertical.add_child(rect)
	
	# generate colors once
	#update_colors()
	
	#print_map(map)
	
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

func init_noise():
	noise = OpenSimplexNoise.new()
	noise.octaves = 5
	noise.period = 30.0
	noise.persistence = 0.4
	noise.lacunarity = 3.0
	
	noise2 = OpenSimplexNoise.new()
	noise2.octaves = 3
	noise2.period = 40.0
	noise2.persistence = 0.4
	noise2.lacunarity = 3.0
	
func fill_colors(map, colorscheme, eye_colorscheme, n_colors, outline = true):
	noise.seed = randi()
	noise2.seed = randi()
	var groups = []
	var negative_groups = []
	
	groups = flood_fill(map, groups, colorscheme, eye_colorscheme, n_colors, false, outline)
	negative_groups = flood_fill_negative(map, negative_groups, colorscheme, eye_colorscheme, n_colors, outline)
	
	return {
		"groups": groups,
		"negative_groups": negative_groups
	}
	
func flood_fill_negative(map, groups, colorscheme, eye_colorscheme, n_colors, outline):
	var negative_map = []
	for x in range(0, map.size()):
		var arr = []
		for y in range(0, map[x].size()):
			arr.append(!get_neighbour_value(map, Vector2(x,y)))
		negative_map.append(arr)
	
	return flood_fill(negative_map, groups, colorscheme, eye_colorscheme, n_colors, true, outline)


func flood_fill(map, groups, colorscheme, eye_colorscheme, n_colors, is_negative = false, outline = true):
	# which pixels have already been checked
	var checked_map = []
	for x in range(0, map.size()):
		var arr = []
		for y in range(0, map[x].size()):
			arr.append(false)
		checked_map.append(arr)
	
	var bucket = []
	for x in range(0, map.size()):
		for y in range(0, map[x].size()):
			if !checked_map[x][y]:
				checked_map[x][y] = true
				
				if map[x][y]:
					bucket.append(Vector2(x,y))
					
					var group = {
						"arr": [],
						"valid": true
					}
				
					# go through all cells in the bucket
					while (bucket.size() > 0):
						var pos = bucket.pop_back()
					
						# get neighbors
						var right = get_neighbour_value(map, pos + Vector2(1,0))
						var left = get_neighbour_value(map, pos + Vector2(-1,0))
						var down = get_neighbour_value(map, pos + Vector2(0,1))
						var up = get_neighbour_value(map, pos + Vector2(0,-1))
						
						if is_negative: # dont want negative groups that touch the edge of the sprite
							if left == null || up == null || down == null || right == null:
								group.valid = false
						
						var color = get_color(map, pos, is_negative, right, left, down, up, colorscheme, eye_colorscheme, n_colors, outline, group)
						
						group.arr.append({
							"position": pos,
							"color": color
						})
						
						if right && !checked_map[pos.x + 1][pos.y]:
							bucket.append(pos + Vector2(1, 0))
							checked_map[pos.x + 1][pos.y] = true
						if left && !checked_map[pos.x - 1][pos.y]:
							bucket.append(pos + Vector2(-1, 0))
							checked_map[pos.x - 1][pos.y] = true
						if down && !checked_map[pos.x][pos.y + 1]:
							bucket.append(pos + Vector2(0, 1))
							checked_map[pos.x][pos.y+1] = true
						if up && !checked_map[pos.x][pos.y - 1]:
							bucket.append(pos + Vector2(0, -1))
							checked_map[pos.x][pos.y-1] = true
					groups.append(group)
	return groups

func get_color(map, pos, is_negative, right, left, down, up, colorscheme, eye_colorscheme, n_colors, outline, group):
	var col_x = ceil(abs(pos.x - (map.size()-1)*0.5))
	var n = pow(abs((noise.get_noise_2d(col_x, pos.y))), 1.5) * 3.0
	var n2 = pow(abs((noise2.get_noise_2d(col_x, pos.y))), 1.5) * 3.0
	
	# highlight colors based on amount of neighbours
	if !down:
		if is_negative:
			n2 -= 0.1
		else:
			n -= 0.45
		n*= 0.8
		if outline:
			group.arr.append({
				"position": pos + Vector2(0, 1),
				"color": Color(0,0,0,1)
			})
	if !right:
		if is_negative:
			n2 += 0.1
		else:
			n += 0.2
		n*=1.1
		if outline:
			group.arr.append({
				"position": pos + Vector2(1, 0),
				"color": Color(0,0,0,1)
			})
	if !up:
		if is_negative:
			n2 +=0.15
		else:
			n += 0.45
		n*=1.2
		if outline:
			group.arr.append({
				"position": pos + Vector2(0, -1),
				"color": Color(0,0,0,1)
			})
	if !left:
		if is_negative:
			n2 += 0.1
		else:
			n += 0.2
		n*=1.1
		if outline:
				group.arr.append({
					"position": pos + Vector2(-1, 0),
					"color": Color(0,0,0,1)
				})

	# highlight colors if the difference in colors between neighbours is big
	var c_0 = colorscheme[floor(noise.get_noise_2d(col_x, pos.y) * (n_colors-1))]
	var c_1 = colorscheme[floor(noise.get_noise_2d(col_x, pos.y - 1) * (n_colors-1))]
	var c_2 = colorscheme[floor(noise.get_noise_2d(col_x, pos.y + 1) * (n_colors-1))]
	var c_3 = colorscheme[floor(noise.get_noise_2d(col_x - 1, pos.y) * (n_colors-1))]
	var c_4 = colorscheme[floor(noise.get_noise_2d(col_x + 1, pos.y) * (n_colors-1))]
	var diff = ((abs(c_0.r - c_1.r) + abs(c_0.g - c_1.g) + abs(c_0.b - c_1.b)) + 
				(abs(c_0.r - c_2.r) + abs(c_0.g - c_2.g) + abs(c_0.b - c_2.b)) + 
				(abs(c_0.r - c_3.r) + abs(c_0.g - c_3.g) + abs(c_0.b - c_3.b)) + 
				(abs(c_0.r - c_4.r) + abs(c_0.g - c_4.g) + abs(c_0.b - c_4.b)))
	if diff > 2.0:
		n+= 0.3
		n*= 1.5
		n2+= 0.3
		n2*= 1.5

	# actually choose a color
	n = clamp(n, 0.0, 1.0)
	n = floor(n * (n_colors-1))
	n2 = clamp(n2, 0.0, 1.0)
	n2 = floor(n2 * (n_colors-1))
	var col = colorscheme[n]
	
	if is_negative:
		col = eye_colorscheme[n2]
	return col

func draw_monster(all_groups):
	var groups = []
	var negative_groups = []
	var draw_size = 4
	var movement = false
	var is_eye = false
	var eye_cutoff = 0.0
	var average = Vector2()
	var sprite = get_node("Viewport/Sprite")
	#onready var cell_drawer = preload("res://SpriteGenerator/CellDrawer.tscn")
	
	var largest = 0
	for g in groups:
		largest = max(largest, g.arr.size())

	# for every row?
	for i in range(groups.size() - 1, -1, -1):
		var g = groups[i].arr
		#if g.size >= largest * 0.25:
		for c in g:
			print("draw rect")
			sprite.draw_rect(Rect2(c.position.x*draw_size, c.position.y*draw_size, draw_size, draw_size), c.color)
	

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
