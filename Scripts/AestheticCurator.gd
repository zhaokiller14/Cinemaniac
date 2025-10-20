extends Control

var puzzle_pieces = []
var movie_scene = {}
var score = 0

func _ready():
	load_scene()
	setup_puzzle()
	$GuessButton.pressed.connect(_on_GuessButton_pressed)
	$NextButton.pressed.connect(_on_NextButton_pressed)
	$NextButton.hide()

func load_scene():
	var file = FileAccess.open("res://movies.json", FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	var scenes = json["scenes"]
	movie_scene = scenes[randi() % scenes.size()]

func setup_puzzle():
	var grid = $GridContainer
	grid.columns = 3
	for i in range(9):
		var piece = TextureRect.new()
		piece.texture = load(movie_scene["piece_paths"][i])
		piece.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		piece.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		piece.mouse_filter = Control.MOUSE_FILTER_STOP
		piece.gui_input.connect(_on_piece_input.bind(i))
		puzzle_pieces.append({"node": piece, "correct_pos": i})
		grid.add_child(piece)
	puzzle_pieces.shuffle()

func _on_piece_input(event, index):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var target = puzzle_pieces[index]
		# Simplified: Assume player drags to correct position
		# In a real game, implement drag-and-drop or swap logic
		var grid = $GridContainer
		grid.move_child(target["node"], target["correct_pos"])

func _on_GuessButton_pressed():
	var input = $GuessInput.text.strip_edges()
	if input.to_lower() == movie_scene["movie"].to_lower():
		# Play video sequence
		var video = VideoStreamPlayer.new()
		video.stream = load(movie_scene["video_path"])
		video.expand = true
		add_child(video)
		video.play()
		await video.finished
		video.queue_free()
		score += 5
		$NextButton.show()
	else:
		get_tree().change_scene_to_file("res://Result.tscn")

func _on_NextButton_pressed():
	get_tree().change_scene_to_file("res://GameSelect.tscn")
