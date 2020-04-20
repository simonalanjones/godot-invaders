extends Area2D

var speed = 60
var vel = Vector2()
var player_can_move = false
var pos
var demo_mode = false

var demo_moves = ['-', '-', '-', '-', '-', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r','r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'l', 'l', 'l', '-', '-', '-', '-', '-', '-', '-', '-', 'l', 'l', 'l', 'l', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'l', 'l', 'l', 'l', 'l', 'l', 'l', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'r', 'r', 'r', 'r', 'r', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'l', 'l', 'l', 'l', 'l', '-', '-', '-', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'l', 'l', 'l', 'l', '-', '-', '-', '-', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r','r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'l', 'l', 'l', 'l', 'l', 'l', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'l', 'l', 'l', 'l', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'l', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'l', 'l', 'l', 'l', 'l', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', '-', 'f', '-', '-', '-', '-', '-', '-', '-', '-', 'f','-', '-', '-', '-', 'x']
var demo_move_pointer = 0

onready var missile = preload("res://scenes/missile.tscn")
onready var main_node = get_node("/root/Main/")

onready var explode_frames = [
	preload("res://sprites/player/player-base-explodes-frame1.png"),
	preload("res://sprites/player/player-base-explodes-frame2.png")
	]

onready var base_texture = preload('res://sprites/player/player-base.png')
onready var frame_pointer = 0
onready var animation_count = 0

signal player_hit
signal player_fires
signal player_explosion_complete
signal player_reset
signal demo_ended
	
# via signal
func start():
	demo_move_pointer = 0
	demo_mode = Scene_switcher.get_param("demo_mode")
	show_base()
	set_position(Vector2(10,218))
	$"Sprite".material.set_shader_param("world_y", position.y)
	$"Sprite".material.set_shader_param("height", $"Sprite".get_texture().get_height())
	
	
func _process(delta):
	# get from signal set in main using function here set_demo_mode()
	if demo_mode == true:
		
		var move = demo_moves[demo_move_pointer] 
		if move == 'x':
			demo_mode = false
			emit_signal('demo_ended')
		if move == 'r' and can_move():
			move_right(delta)
		if move == 'l' and can_move():
			move_left(delta)
		if move == 'f' and can_move():
			if !main_node.has_node("Missile"):
				var m = missile.instance()
				var missile_start = get_node("Missile_start")
				var mpos = Vector2(missile_start.global_position.x,missile_start.global_position.y)
				m.set_position(mpos)
				main_node.add_child(m)
				emit_signal('player_fires')
				
		if demo_move_pointer < demo_moves.size():
			demo_move_pointer+=1
			
	else:
		
		if can_move():
			if Input.is_action_pressed("left"):
				move_left(delta)
			if Input.is_action_pressed("right"):
				move_right(delta)
			
func clear_player_missile():
	if has_node("Missile"):
		get_node("Missile").queue_free()
		
func hide_base():
	self.visible = false
	player_can_move = false

func show_base():
	self.visible = true
	player_can_move = true
			
func reset_base():
	if demo_mode == false:
		show_base()
		get_node("Sprite").set_texture(base_texture)
		set_position(Vector2(10,218))
		emit_signal('player_reset')

func explode():
	player_can_move = false
	animation_count = 0
	while animation_count < 8:		
		frame_pointer = int(!frame_pointer) #cycle between frame 0 and 1

		var explode_frame = explode_frames[frame_pointer]
		get_node("Sprite").set_texture(explode_frame)
		yield(get_tree().create_timer(.08),"timeout")
		animation_count +=1
	hide_base()
	clear_player_missile()
	yield(get_tree().create_timer(1),"timeout") #small delay to allow bombs clear
	if demo_mode == true:
		demo_mode = false
		emit_signal('demo_ended')
	else:
		emit_signal("player_explosion_complete")
		
	
func _input(event):
		
	if event.is_action_pressed("fire") and can_move():

		if !main_node.has_node("Missile"):
			var m = missile.instance()
			var missile_start = get_node("Missile_start")
			var mpos = Vector2(missile_start.global_position.x,missile_start.global_position.y)
			m.set_position(mpos)
			main_node.add_child(m)
			emit_signal('player_fires')
			
# use _process to detect key press with delta etc
func move_left(delta):
	var input = Vector2(0,0)
	
	input.x = -1
	vel = input * speed
	pos = get_position() + vel * delta
	pos.x = clamp(pos.x, 10, 200)
	set_position(pos)

func move_right(delta):
	var input = Vector2(0,0)
	input.x = 1
	vel = input * speed
	pos = get_position() + vel * delta
	pos.x = clamp(pos.x, 10, 200)
	set_position(pos)	

	
func _on_Player_area_entered(area):
	if area.is_in_group('bomb') and player_can_move == true:
		# easter egg! - invader bombs on row above you can't hit you
		if area.move_count > 5:
			area.remove_from_scene()
			player_can_move = false
			emit_signal("player_hit")
			explode()

func can_move():
	return true if player_can_move == true else false