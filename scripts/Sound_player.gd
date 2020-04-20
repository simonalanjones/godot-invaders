extends Node

var move1_sound
var move2_sound
var move3_sound
var move4_sound

var shoot_sound
var invader_destroyed_sound
var extra_life_sound
var player_explode_sound
var mothership_sound
var mothership_bonus_sound

var move_sound_pointer = 1 # there are 4 move sounds
var move_sound_enabled = false
var sound_counter = 0
var demo_mode = false
var fleet_sound_delay = 52
var fleet_sound_dict = { 50:52, 43:46, 36:39, 28:34, 22:28, 17:24, 13:21, 10:19, 8:16, 7:14, 6:13, 5:12, 4:11, 3:9, 2:7, 1:5 }
	
func _ready():
	demo_mode = Scene_switcher.get_param("demo_mode")
	mothership_sound = AudioStreamPlayer.new()
	mothership_sound.set_bus('invader_move')
	mothership_sound.stream = load("res://sounds/mothership.wav")
	self.add_child(mothership_sound)

	mothership_bonus_sound = AudioStreamPlayer.new()
	mothership_bonus_sound.stream = load("res://sounds/mothership_bonus.wav")
	self.add_child(mothership_bonus_sound)
	
	player_explode_sound = AudioStreamPlayer.new()
	player_explode_sound.stream = load("res://sounds/player_destroyed.wav")
	self.add_child(player_explode_sound)
	
	shoot_sound = AudioStreamPlayer.new()
	shoot_sound.stream = load("res://sounds/player_shoot.wav")
	self.add_child(shoot_sound)
	
	invader_destroyed_sound = AudioStreamPlayer.new()
	invader_destroyed_sound.stream = load("res://sounds/invader_destroyed.wav")
	self.add_child(invader_destroyed_sound)
	
	extra_life_sound = AudioStreamPlayer.new()
	extra_life_sound.stream = load("res://sounds/extra_life.wav")
	self.add_child(extra_life_sound)

	move1_sound = AudioStreamPlayer.new()
	move1_sound.stream = load("res://sounds/move1.wav")
	self.add_child(move1_sound)

	move2_sound = AudioStreamPlayer.new()
	move2_sound.stream = load("res://sounds/move2.wav")
	self.add_child(move2_sound)
	
	move3_sound = AudioStreamPlayer.new()
	move3_sound.stream = load("res://sounds/move3.wav")
	self.add_child(move3_sound)	
	
	move4_sound = AudioStreamPlayer.new()
	move4_sound.stream = load("res://sounds/move4.wav")
	self.add_child(move4_sound)
	
	
func _process(_delta):	
	if move_sound_enabled == true && demo_mode == false:
		sound_counter+=1
		if sound_counter >= fleet_sound_delay:
			sound_counter = 0
			play_invader_move_sound()
			fleet_sound_delay = calc_fleet_sound_delay()

func calc_fleet_sound_delay():
	var num_invaders = get_tree().get_nodes_in_group('invader').size()
	for num in fleet_sound_dict.keys():
		if num_invaders >= num:
			return fleet_sound_dict[num]

func enable_move_sound():
	move_sound_pointer = 1
	move_sound_enabled = true

func disable_move_sound():
	move_sound_enabled = false	
				
func get_move_sound():
	match move_sound_pointer:
		1: return move1_sound
		2: return move2_sound
		3: return move3_sound
		4: return move4_sound

func play_invader_move_sound():
	var move_sound = get_move_sound()
	move_sound.play()
	
	move_sound_pointer +=1
	if move_sound_pointer>4:
		move_sound_pointer = 1
	
func player_shoot_sound():
	if demo_mode == false:
		shoot_sound.play()

func player_extra_life_sound():
	extra_life_sound.play()
	
func play_player_explode_sound():
	if demo_mode == false:
		player_explode_sound.play()
	
func invader_explode_sound():
	if demo_mode == false:
		invader_destroyed_sound.play()
	
func play_mothership_sound():
	if demo_mode == false:
		mothership_sound.play()

func play_mothership_bonus_sound():
	if demo_mode == false:
		stop_mothership_sound()
		mothership_bonus_sound.play()	
	
func stop_mothership_sound():
	mothership_sound.stop()