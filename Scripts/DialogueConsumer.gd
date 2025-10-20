extends Control

var quotes = []
var current_quote_index = 0
var score = 0
var skipped_quote = null

func _ready():
	load_quotes()
	$Timer.start()
	update_quote()
	$GuessButton.pressed.connect(_on_GuessButton_pressed)
	$SkipButton.pressed.connect(_on_SkipButton_pressed)
	$NextButton.pressed.connect(_on_NextButton_pressed)
	$NextButton.hide()

func load_quotes():
	var file = FileAccess.open("res://movies.json", FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	quotes = json["quotes"]
	quotes.shuffle()

func update_quote():
	if current_quote_index < quotes.size():
		$QuoteLabel.text = quotes[current_quote_index]["quote"]
	else:
		check_win()

func _on_GuessButton_pressed():
	var input = $GuessInput.text.strip_edges()
	if input.to_lower() == quotes[current_quote_index]["movie"].to_lower():
		score += 1
	current_quote_index += 1
	$GuessInput.text = ""
	update_quote()

func _on_SkipButton_pressed():
	if skipped_quote == null:
		skipped_quote = quotes[current_quote_index]
		current_quote_index += 1
		update_quote()

func _on_timeout():
	if skipped_quote:
		quotes.append(skipped_quote)
		skipped_quote = null
	current_quote_index += 1
	update_quote()

func check_win():
	if score >= 8:
		get_tree().root.get_node("/root/MainMenu").score += 5
		$NextButton.show()
	else:
		get_tree().change_scene_to_file("res://Result.tscn")

func _on_NextButton_pressed():
	get_tree().change_scene_to_file("res://GameSelect.tscn")
