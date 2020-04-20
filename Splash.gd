extends Node2D


func _input(event):
	if event.is_action_pressed("ui_up"):
		$"Background/AnimationPlayer".play("wipe")
		yield(get_tree().create_timer(.5),"timeout") #small delay for wipe transition
		
		if get_tree().change_scene("res://scenes/Intro.tscn")!= OK:
			print ("An error occured when trying to switch to the main scene")

