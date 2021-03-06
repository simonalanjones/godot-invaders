extends Area2D

var frame_pointer
var fire_frames
var type = 'rolling'
var status = true
var height
var move_count = 0

signal bomb_grounded
signal rolling_shot_ended

var alien_shot_explodes = preload("res://sprites/alien-shot-exploding.png")

var rolling_fire_frames = [
	preload("res://sprites/invader-fire/invader-fire-rolling-frame1.png"),
	preload("res://sprites/invader-fire/invader-fire-rolling-frame2.png"),
	preload("res://sprites/invader-fire/invader-fire-rolling-frame3.png"),
	preload("res://sprites/invader-fire/invader-fire-rolling-frame4.png"),	
	]
	
func _ready():
	frame_pointer = 0
	$Sprite.set_texture(rolling_fire_frames[0])
	height = $Sprite.get_texture().get_height()

func move(delta_y = 4):
	if status == true:
		move_count +=1
		#if status == true:
		get_node("Sprite").set_texture(get_texture())
		
		$"Sprite".material.set_shader_param("world_y", position.y)
		$"Sprite".material.set_shader_param("height", height)
		if position.y<231 and status == true:
			position.y = position.y + delta_y
		else:
			#emit_signal("bomb_grounded", global_position.x)
			emit_signal('rolling_shot_ended')
			explode(0.15)
			
func explode(wait=1.0):
	status = false #stop it moving
	get_node("Sprite").position.x -=2
	get_node("Sprite").set_texture(alien_shot_explodes)
	var timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(wait)
	timer.connect('timeout',self,'remove_from_scene')
	timer.start()
	add_child(timer)
	

func get_texture():
	frame_pointer+=1
	if frame_pointer == rolling_fire_frames.size():
		frame_pointer = 0
	return rolling_fire_frames[frame_pointer]
	
func remove_from_scene():
	queue_free()

func _on_Bomb_area_entered(area):
	#if area.get_parent().get_name() != 'Invader_container':
	#print(area.get_parent().get_name())
	emit_signal('rolling_shot_ended')
	#if area.get_name() == 'Missile':
	#area.explode()
	#explode(0.2)