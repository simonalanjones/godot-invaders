extends Node

onready var invader_scene = preload("res://scenes/Invader.tscn")
var spawn_rows = [ 120,144,160,168,168,168,176,176,176 ]
var spawn_rows_pointer = 8

var invader_direction_right_last_alien = 3
var invader_direction = 2
var invader_down_direction = 8

var invader_pointer = 0
var invader_move_down = false

var invader_rows = 11
var invader_cols = 5
var left_margin = 25
var right_margin = 200

signal invaders_did_land

signal invaders_spawned
signal cleared_level
signal hit
signal score_add(score_add)


func _ready():
	pass
	
func next_level():
	invader_direction = 2
	spawn_rows_pointer+=1
	if spawn_rows_pointer>8:
		spawn_rows_pointer = 8
	spawn_invaders()

func get_invaders():
	return get_tree().get_nodes_in_group('invader')

func get_invader_count():
	return get_invaders().size()

# move one invader using the pointer variable (invader_pointer)
func _process(_delta):
	# dont move any invaders while an invader is exploding or before all have spawned
	if get_invader_count() > 0 and check_invaders() == true:
		
		if invader_move_down == false:
			move_across()
		else:
			move_down()

		# update invader pointer
		if invader_pointer >= get_invader_count()-1:
			invader_pointer = 0
			# change direction and start move down mode if first invader is at screen edge
			if check_move_limits() == true:
				invader_direction = invader_direction * -1
				invader_move_down = true
		else:
			invader_pointer+=1	
			
		
# move invader left or right across screen				
func move_across():
	var invader = get_child(invader_pointer)
	if is_instance_valid(invader):
		# note: last invader moves right 3 pixels but left 2 pixels
		if get_invader_count() == 1 and invader_direction>0:
			invader.move(invader_direction_right_last_alien)
		else:
			invader.move(invader_direction)

# move invader down the screen		
func move_down():
	var invader = get_child(invader_pointer)
	if is_instance_valid(invader):
		invader.move_down(invader_down_direction)
		# check with the invader instance to see if new position is landed
		if invader.has_landed():
			emit_signal("invaders_did_land")
			get_tree().call_group('invader','disable_moving')
				
	# if we reach the last invader then cancel move_down mode	
	if invader_pointer >= get_invader_count()-1:
		invader_move_down = false


# check there isn't an invader exploding
func check_invaders()-> bool:
	for invader in get_invaders():
		if invader.get_status() == false:
			return false
	return true
	

# check there isn't an invader at screen edge	
func check_move_limits()-> bool:
	for invader in get_invaders():
		if invader.position.x >= right_margin and invader_direction>0:
			return true
		elif invader.position.x <= left_margin and invader_direction<0:
			return true
	return false
	
		
func spawn_invaders():
	var y_start = spawn_rows[spawn_rows_pointer]
	for y in range (invader_cols):
		for x in range (invader_rows):
			var invader = invader_scene.instance()
			invader.set_row(y) # used to determine score when hit
			invader.connect("invader_hit", self, "_on_invader_hit")
			var position = Vector2(16+(x*16),y_start-(y*17))
			invader.set_position(position)
			add_child(invader)
			yield(get_tree().create_timer(0.01),"timeout")
	emit_signal('invaders_spawned')
	get_tree().call_group('invader','enable_moving')
	


func _on_invader_hit(area,score_add,invader_index):
	
	emit_signal("hit")
	emit_signal("score_add", score_add)
		
	#as the array size of invaders changes
	#adjust invader pointer back one
	#if invader pointer is beyond invader being destroyed
	if invader_pointer>invader_index:
		invader_pointer-=1

	area = false # area is what hit it (eg missile)
	
	if get_invader_count()-1 == 0:
		emit_signal('cleared_level')
