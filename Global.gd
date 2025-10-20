extends Node

var score: int = 0
var games_won: int = 0
var total_games: int = 3

signal score_updated(new_score: int)
signal game_won(game_name: String)

func add_score(points: int):
	score += points
	games_won += 1
	score_updated.emit(score)
	print("Score updated: ", score, " | Games won: ", games_won)

func reset_game():
	score = 0
	games_won = 0
	print("Game reset")

func is_game_won() -> bool:
	return games_won >= total_games

func get_score() -> int:
	return score

func get_games_won() -> int:
	return games_won
