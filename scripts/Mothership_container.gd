extends Node

onready var mothership_scene = preload("res://scenes/Mothership.tscn")
onready var exploding_frame = preload("res://sprites/mothership/mothership-exploding.png")

var scores = [ 50,50,50,50,50,100,100,100,100,100,100,100,100,150,150,300 ]

signal mothership_spawn
signal mothership_screen_exit
signal mothership_hit
signal score_add(score)

var status = false
var direction
var shot_counter = 0
var timer_can_resume = true

func game_ended():
	timer_can_resume = false
	$Spawn_timer.set_paused(true)
			
func pause_timer():
	if status == false:
		$Spawn_timer.set_paused(true)
	
func resume_timer():
	if status == false:
		$Spawn_timer.set_paused(false)
	
# this is first fired as a signal when invaders spawned	
func start_timer():
	$Spawn_timer.start()
	
func spawn():
	if get_tree().get_nodes_in_group('invader').size() >= 8:
		pause_timer()
		emit_signal('mothership_spawn')
		status = true
		var mothership = mothership_scene.instance()
	
		# even shot counter number means mothership comes from the right
		if shot_counter % 2 == 1:
			direction = -1
			var spawn_point = get_node("/root/Main/Mothership_spawn_point_right")
			var spawn_position = Vector2(spawn_point.position.x,spawn_point.position.y)
			mothership.set_position(spawn_position)
		else:
			direction = 1
			var spawn_point = get_node("/root/Main/Mothership_spawn_point_left")
			var spawn_position = Vector2(spawn_point.position.x,spawn_point.position.y)
			mothership.set_position(spawn_position)
	
		mothership.connect("mothership_hit", self, "_on_mothership_hit")	
		add_child(mothership)
	
	
func _process(_delta):
	#print($Spawn_timer.get_time_left())
	if status == true:
		
		# moving right?
		if direction == 1 and has_node("Mothership"):
			if get_node("Mothership").position.x<224-16 and status == true:
				get_node("Mothership").position.x += .7
			if get_node("Mothership").position.x>224-16:
				mothership_exit()
			
		# moving left
		if direction == -1 and has_node("Mothership"):
			
			if get_node("Mothership").position.x>-0 and status == true:
				get_node("Mothership").position.x += -.7
			if get_node("Mothership").position.x < -0:
				mothership_exit()
		
func mothership_exit():
	status = false
	emit_signal('mothership_screen_exit')
	if has_node("Mothership"):
		get_node("Mothership").queue_free()
	if timer_can_resume == true:
		resume_timer()
			
func _on_mothership_hit():
	
	# we can't reference the label/sprite nodes in advance
	# as they don't exist at runtime
	
	var score = get_score()
	#hit = true
	status = false # stop mothership moving
	#area.queue_free() #remove the player missile
	emit_signal('mothership_hit')
	get_node("Mothership/Sprite").set_texture(exploding_frame)
		
	yield(get_tree().create_timer(.5),"timeout")
	
	get_node('Mothership/Score_label').text = str(score)
	get_node('Mothership/Score_label').visible = true
	get_node('Mothership/Sprite').visible = false
	yield(get_tree().create_timer(1),"timeout")
	emit_signal("score_add", score)
	if has_node("Mothership"):
		get_node("Mothership").queue_free()
	shot_counter = 0
	resume_timer()
	
	
# the score is dependant on the player shot count
func get_score():
	var bonus_score = scores[shot_counter]
	return bonus_score
	
# every time player shoots a missile we track the count.
# the left/right spawn position of the mothership is dependant on
# odd or even number. Connected as a signal in main.gd
func increase_counter():
	if status == false:
		shot_counter+=1
		if shot_counter > 15:
			shot_counter = 0