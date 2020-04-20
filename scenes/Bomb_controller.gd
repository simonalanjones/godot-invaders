extends Node

var enabled = true
var max_bombs = 3
var grace_period_count = 70 # allow short time before dropping bombs

var reload_delay_dict = { 200:70, 1000:60, 2000:50, 3000:30 }
var reload_delay = 80 # default reload delay before 200 points
var demo_mode = false

onready var bomb_scene = preload("res://scenes/Bomb.tscn")

func _ready():
	demo_mode = Scene_switcher.get_param("demo_mode")
	
# via signal
func score_updated(score):
	for num in reload_delay_dict.keys():
		if score >= num:
			reload_delay = reload_delay_dict[num]

#via signal		
func start_bombs():
	enabled = true
	grace_period_count = 100
	
# via signal	
func stop_bombs():
	enabled = false

func get_invaders():
	return get_tree().get_nodes_in_group('invader')
	
func get_invader_count():
	return get_tree().get_nodes_in_group('invader').size()

# only one rolling shot at a time
func has_rolling_shot():
	for bomb in get_tree().get_nodes_in_group('bomb'):
		if bomb.type == 2:
			return true
	return false


# get number of bombs on screen	
func get_bomb_count():
	return get_tree().get_nodes_in_group('bomb').size()


# make sure any bombs have moved enough before launching another - this is the reload speed
func min_moves_made():
	if get_bomb_count()>0:
		var moves = []
		for bomb in get_tree().get_nodes_in_group('bomb'):
			moves.append(bomb.move_count)
			
		if moves.min()>=reload_delay:
			return true
		else:
			return false
	# none on screen - ok to drop one
	else:
		return true


# USED FOR SQUIGGLY AND PLUNGER SHOT
# an invader cant be selected to drop a bomb if its status is false
# when player is hit all invaders get the false status
func get_invader_at_column(column):	
	for invader in get_invaders():
		if invader.get_column() == column and invader.status == true and invader.has_clear_path():
			return invader
	return null
	

# an invader cant be selected to drop a bomb if its status is false
# when player is hit all invaders get the false status
func find_invaders_with_clear_path():
	var possibles = []
	if get_invader_count()>0:
		for invader in get_invaders():
			if invader.has_clear_path() and invader.status == true:
				possibles.append(invader)
		return possibles
	

# used for rolling shot - dropped by attacking invader
func find_attacking_invader():
	for invader in get_invaders():
		# mid point of invader
		var x1 = invader.get_node("Collision").global_position.x + 8
		var px1 = get_node("/root/Main/Player/Collision").global_position.x;
		var px2 = px1 + 16
		
		# choose invader if mid point is within player width
		if x1 >= px1 and x1 <= px2 and invader.status == true:
			return invader
	return -1		


func find_random_invader():
	randomize()
	var possibles = find_invaders_with_clear_path()
	if possibles.size()>0:
		var r = randi() % possibles.size()
		var random_invader = possibles[r]
		return random_invader
	else:
		return -1

func get_attacking_invader(bomb_type):	
	if bomb_type == 0 or bomb_type == 1 or demo_mode == true:
		return find_random_invader()
	else:
		return find_attacking_invader()


func _process(_delta):
	# allow a short period without enemy fire
	if grace_period_count>0:
		grace_period_count-=1
			
	if grace_period_count <= 0 and get_invader_count()>0 and enabled == true:
		if get_bomb_count() < max_bombs and min_moves_made() == true:
			
			var bomb_type

			if has_rolling_shot():
				bomb_type = randi()%2
			else:
				bomb_type = randi()%3
			
			# -1 means not found
			var random_invader = get_attacking_invader(bomb_type)

			if is_instance_valid(random_invader):
				
				var launch_vector = random_invader.get_lauch_vector()
				var new_bomb = bomb_scene.instance()
				new_bomb.set_position(launch_vector)
					
				# bomb speed increases for last 8 invaders
				if get_invader_count() >= 8:
					new_bomb.set_speed(1)
				else:
					new_bomb.set_speed(1.5)	
				
				add_child(new_bomb)
				new_bomb.set_type(bomb_type)