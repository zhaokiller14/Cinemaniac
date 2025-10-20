extends Control

func _ready():
	var final_score = Global.score  # Simple access via autoload
	$ScoreLabel.text = "Final Score: %d" % final_score
	$GamesWonLabel.text = "Games Won: %d/3" % Global.games_won  # Optional
	
	if Global.is_game_won():
		$ResultLabel.text = "Congratulations! You Won!"
	else:
		$ResultLabel.text = "Game Over! You Lost!"
	
func _on_RestartButton_pressed():
	Global.reset_game()  # Reset everything
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
