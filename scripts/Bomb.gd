extends Area2D

var frame_pointer
var fire_frames
var speed = 1.3
var type
var status = true
var height
var move_count = 0

signal bomb_grounded

var alien_shot_explodes = preload("res://sprites/alien-shot-exploding.png")

var plunger_fire_frames = [
	preload("res://sprites/invader-fire/invader-fire-plunger-frame1.png"),
	preload("res://sprites/invader-fire/invader-fire-plunger-frame2.png"),
	preload("res://sprites/invader-fire/invader-fire-plunger-frame3.png"),
	preload("res://sprites/invader-fire/invader-fire-plunger-frame4.png"),
	]

var squiggly_fire_frames = [
	preload("res://sprites/invader-fire/invader-fire-squiggly-frame1.png"),
	preload("res://sprites/invader-fire/invader-fire-squiggly-frame2.png"),
	preload("res://sprites/invader-fire/invader-fire-squiggly-frame3.png"),
	preload("res://sprites/invader-fire/invader-fire-squiggly-frame4.png"),	
	]
	
var rolling_fire_frames = [
	preload("res://sprites/invader-fire/invader-fire-rolling-frame1.png"),
	preload("res://sprites/invader-fire/invader-fire-rolling-frame2.png"),
	preload("res://sprites/invader-fire/invader-fire-rolling-frame3.png"),
	preload("res://sprites/invader-fire/invader-fire-rolling-frame4.png"),	
	]	

func stop():
	status = false
	
func start():
	status = true
	
func _ready():
	add_to_group('bomb')

# overide the frame type set randomly
func set_type(r):
	type = r
	fire_frames = get_frames(r)
	$"Label".text = str(r)
	fire_frames = get_frames(r)	
	frame_pointer = 0
	$Sprite.set_texture(get_texture())
	height = $Sprite.get_texture().get_height()
	
	
func set_speed(pixels_per_frame):
	speed = pixels_per_frame * 1.3
	
func get_frames(r):
	match r:
		0: return plunger_fire_frames
		1: return squiggly_fire_frames
		2: return rolling_fire_frames
		
func _process(_delta):
	if status == true:
		move_count +=1
		$"Sprite".material.set_shader_param("world_y", position.y)
		$"Sprite".material.set_shader_param("height", height)
		if position.y<231 and status == true:
			position.y = position.y + speed
		else:
			emit_signal("bomb_grounded", global_position.x)
			explode(0.2)

func explode(wait=1.0):
	status = false #stop it moving
	$"Frame_timer".stop() #stop the timer changing the frame texture
	get_node("Sprite").position.x -=2
	get_node("Sprite").set_texture(alien_shot_explodes)
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(wait)
	timer.connect('timeout',self,'remove_from_scene')
	timer.start()
	add_child(timer)
	
# frames are set on timer timeout
func _on_Frame_timer_timeout():
	if status == true:
		get_node("Sprite").set_texture(get_texture())

func get_texture():
	frame_pointer+=1
	if frame_pointer == fire_frames.size():
		frame_pointer = 0
	return fire_frames[frame_pointer]
	
func remove_from_scene():
	queue_free()

func _on_Bomb_area_entered(area):
	if area.get_name() == 'Missile':
		area.explode()
		if type == 1 or type == 2:
			explode(0.2)
			
func _on_Bomb_bomb_grounded(x_position):
	get_node("/root/Main/Baseline").take_damage(x_position)
