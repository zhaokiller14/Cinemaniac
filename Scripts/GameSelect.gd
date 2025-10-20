extends Control

func _ready():
	# Connect buttons for each game
	$MovieCriticButton.pressed.connect(_on_MovieCriticButton_pressed)
	$AestheticCuratorButton.pressed.connect(_on_AestheticCuratorButton_pressed)
	$DialogueConsumerButton.pressed.connect(_on_DialogueConsumerButton_pressed)
	# Disable buttons for games already played (if tracked)

func _on_MovieCriticButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MovieCritic.tscn")

func _on_AestheticCuratorButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/AestheticCurator.tscn")

func _on_DialogueConsumerButton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/DialogueConsumer.tscn")
