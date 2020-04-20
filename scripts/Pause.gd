extends Node

func _input(event):
	if event.is_action_pressed("pause"):
		print("Game Paused")
		get_tree().paused = !get_tree().paused