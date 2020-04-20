extends Area2D

signal mothership_hit

func _on_Mothership_area_entered(area):
	if area.get_name()=='Missile':
		area.queue_free() #remove the player missile
		emit_signal('mothership_hit')