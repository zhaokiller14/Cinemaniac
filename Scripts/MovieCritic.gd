extends Control

var movies = []  # Loaded from JSON
var correct_order = []  # Based on IMDB ratings
var current_order = []  # Player's current order
var selected_poster = null  # Track selected poster index (-1 = none selected)
var score = 0
var correct_titles = []
var current_titles = []
# Style for selected poster border
var selected_style: StyleBoxFlat
var default_style: StyleBoxFlat

func _ready():
	# Create highlight style for selected poster
	create_highlight_style()
	
	load_movies()
	setup_posters()
	$NextButton.hide()

func create_highlight_style():
	# Default style (no border)
	default_style = StyleBoxFlat.new()
	default_style.bg_color = Color.TRANSPARENT
	
	# Selected style (yellow border)
	selected_style = StyleBoxFlat.new()
	selected_style.bg_color = Color(1, 1, 0, 0.3)  # Semi-transparent yellow background
	selected_style.border_width_left = 4
	selected_style.border_width_top = 4
	selected_style.border_width_right = 4
	selected_style.border_width_bottom = 4
	selected_style.border_color = Color(1, 1, 0, 1)  # Bright yellow border
	selected_style.corner_radius_top_left = 8
	selected_style.corner_radius_top_right = 8
	selected_style.corner_radius_bottom_right = 8
	selected_style.corner_radius_bottom_left = 8

func load_movies():
	var file = FileAccess.open("res://data/movies.json", FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	movies = json["movies"]
	# Select 10 random movies
	var indices = range(movies.size())
	indices.shuffle()
	movies = indices.slice(0, 10).map(func(i): return movies[i])
	# Sort by IMDB rating for correct order
	correct_order = movies.duplicate()
	correct_order.sort_custom(func(a, b): return a["imdb_rating"] > b["imdb_rating"])
	# Shuffle for display
	current_order = movies.duplicate()
	current_order.shuffle()
	
	for i in range(10):
		correct_titles.append(correct_order[i]["title"])
		current_titles.append(current_order[i]["title"])
	print(correct_titles)
	print(current_titles)

func setup_posters():
	# Access manually placed TextureRect nodes
	var posters = []
	for i in range(1, 11):
		posters.append(get_node("Poster" + str(i)))  # Poster1 to Poster10
	
	# Assign textures, set sizes, and connect signals
	for i in range(10):
		posters[i].texture = load(current_order[i]["poster_path"])
		# Enforce uniform size
		
		# Apply default style
		posters[i].add_theme_stylebox_override("panel", default_style)
		
		# Disconnect any existing signals to avoid duplicates
		if posters[i].is_connected("gui_input", _on_poster_input):
			posters[i].disconnect("gui_input", _on_poster_input)
		posters[i].gui_input.connect(_on_poster_input.bind(i))

func _on_poster_input(event, index):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		handle_poster_click(index)

func handle_poster_click(index):
	var posters = []
	for i in range(1, 11):
		posters.append(get_node("Poster" + str(i)))
	
	if selected_poster == null:
		# First click: select this poster
		selected_poster = index
		posters[index].add_theme_stylebox_override("panel", selected_style)
		print("Selected poster ", index + 1, ": ", current_order[index]["title"])
	elif selected_poster != index:
		# Second click on different poster: swap them
		print("Swapping poster ", selected_poster + 1, " with poster ", index + 1)
		
		# Swap in current_order array
		var temp = current_order[selected_poster]
		current_order[selected_poster] = current_order[index]
		current_order[index] = temp
		
		# Update display
		update_poster_display()
		
		print(correct_titles)
		print(current_titles)
	
		# Clear selection
		selected_poster = null
		
		# Optional: Check win condition after each swap
		# check_win()
	else:
		# Clicked on same poster: deselect
		selected_poster = null
		posters[index].add_theme_stylebox_override("panel", default_style)

func update_poster_display():
	# Access manually placed TextureRect nodes
	var posters = []
	for i in range(1, 11):
		posters.append(get_node("Poster" + str(i)))
	
	# Update textures and maintain size/settings
	for i in range(10):
		posters[i].texture = load(current_order[i]["poster_path"])
		
		# Apply appropriate style based on selection
		if selected_poster == i:
			posters[i].add_theme_stylebox_override("panel", selected_style)
		else:
			posters[i].add_theme_stylebox_override("panel", default_style)

# Call this when you want to check win condition (e.g., add a Check button)
func check_win():
	var correct_count = 0
	print(current_titles)
	print(correct_titles)
	for i in range(10):
		if current_titles[i] == correct_titles[i]:
			correct_count += 1
	print("Correct: ", correct_count, "/10")
	
	if correct_count >= 8:
		score += 5
		$NextButton.show()
		print("YOU WIN! Score: ", score)
	else:
		get_tree().change_scene_to_file("res://Scenes/Result.tscn")


func _on_SubmitButton_pressed() -> void:
	print("SUBMIT")
	check_win()

func _on_NextButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GameSelect.tscn")

	
