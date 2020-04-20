extends Area2D

var frame_pointer
var fire_frames
var type = 'squiggly'
var status = true
var height
var move_count = 0

signal bomb_grounded
signal squiggly_shot_ended


var alien_shot_explodes = preload("res://sprites/alien-shot-exploding.png")

var squiggly_fire_frames = [
	preload("res://sprites/invader-fire/invader-fire-squiggly-frame1.png"),
	preload("res://sprites/invader-fire/invader-fire-squiggly-frame2.png"),
	preload("res://sprites/invader-fire/invader-fire-squiggly-frame3.png"),
	preload("res://sprites/invader-fire/invader-fire-squiggly-frame4.png"),	
	]
	
func _ready():
	frame_pointer = 0
	$Sprite.set_texture(squiggly_fire_frames[0])
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
			emit_signal('squiggly_shot_ended')
			explode(0.15)
			
		
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
	pass
	

func get_texture():
	frame_pointer+=1
	if frame_pointer == squiggly_fire_frames.size():
		frame_pointer = 0
	return squiggly_fire_frames[frame_pointer]
	
func remove_from_scene():
	queue_free()

func _on_Bomb_area_entered(area):
	#if area.get_parent().get_name() != 'Invader_container':
	#print(area.get_parent().get_name())
	emit_signal('squiggly_shot_ended')
	#if area.get_name() == 'Missile':
	#area.explode()
	#explode(0.2)