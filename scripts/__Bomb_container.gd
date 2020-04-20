extends Node

var max_bombs = 3
var grace_period_count = 15 # allow short time before dropping bombs
onready var invader_container = get_node("/root/Main/Invader_container")
onready var bomb_scene = preload("res://scenes/Bomb.tscn")


# this needs starting off each time to restart the grace period
func start():
	grace_period_count = 15

# only one rolling shot at a time
func has_rolling_shot():
	for bomb in get_children():
		if bomb.type == 2:
			return true
	return false
	
# make sure any bombs have moved enough before launching another - this is the reload speed
func min_moves_made():
	if get_child_count()>0:
		var moves = []
		for bomb in get_children():
			if bomb.move_count>0:
				moves.append(bomb.move_count)
				
		if moves.min()>=38:
			return true
		else:
			return false
	# none on screen - ok to drop one
	else:
		return true
		

func _on_Bomb_drop_timer_timeout():
	
	#get_tree().call_group("bombs", "say_hello")
	
	"""print('group:')
	for child in get_tree().get_nodes_in_group('bombs'):
		child.say_hello()
		#print(child.get_parent().get_name())
	print('-----')"""
	# allow a short period without enemy fire
	if grace_period_count>0:
		grace_period_count-=1
			
	if grace_period_count == 0 and invader_container.get_child_count() > 0 and invader_container.invaders_stopped == false:
		if get_child_count() < max_bombs and min_moves_made() == true:
			
			var bomb_type

			if has_rolling_shot():
				bomb_type = randi()%2
			else:
				bomb_type = randi()%3
				
			var random_invader = invader_container.get_attacking_invader(bomb_type)
					
			if is_instance_valid(random_invader):
				
				var launch_vector = random_invader.get_lauch_vector()
				var new_bomb = bomb_scene.instance()
				new_bomb.set_position(launch_vector)
					
				# bomb speed increases for last 8 invaders
				if invader_container.get_child_count() > 8:
					new_bomb.set_speed(1)
				else:
					new_bomb.set_speed(1.5)	
				
				add_child(new_bomb)
				
				new_bomb.set_type(bomb_type)