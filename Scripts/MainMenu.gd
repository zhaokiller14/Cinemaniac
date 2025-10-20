extends Control

func _ready():
	$StartAnimation.play("new_animation")
	$StartButton.pressed.connect(_on_StartButton_pressed)

func _on_StartButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GameSelect.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_StartButton_pressed()

# Optional: Display current score
func _process(_delta):
	if $ScoreLabel:  # If you have a score label
		$ScoreLabel.text = "Score: %d" % Global.score
