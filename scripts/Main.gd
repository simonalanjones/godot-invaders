extends Node

var demo_mode = false
var lives = 3
var is_game_over = false

signal game_ended #use this to shutdown any nodes that might be working?

onready var get_ready_text = $"HUD holder/HUD/Ready_player_text"
onready var scoreboard_node = get_node("/root/Main/Scoreboard")
onready var sound_node = get_node("/root/Main/Sound_player")
onready	var player_node = get_node("/root/Main/Player")
onready var invader_controller_node = get_node("/root/Main/Invader_controller")
onready var mothership_container_node = get_node("/root/Main/Mothership_container")
onready var bomb_controller_node = get_node("/root/Main/Bomb_controller")
onready var hud_node = get_node("/root/Main/HUD holder")
onready var shield_container_node = get_node("/root/Main/Shield_container")
onready var baseline_node = get_node("/root/Main/Baseline")


func _ready():	
	is_game_over = false
	player_node.hide_base()
	demo_mode = Scene_switcher.get_param("demo_mode")
	var _e = self.connect("game_ended",mothership_container_node,'game_ended')
	player_node.connect('player_hit', bomb_controller_node, "stop_bombs")
	player_node.connect('player_reset', bomb_controller_node, "start_bombs")
	player_node.connect('player_reset', mothership_container_node, "resume_timer")
	player_node.connect('player_reset', sound_node, "enable_move_sound")	
	player_node.connect('player_hit', sound_node, "play_player_explode_sound")
	player_node.connect('player_hit', mothership_container_node, "pause_timer")
	player_node.connect('player_hit', sound_node, "disable_move_sound")
	player_node.connect('player_fires',sound_node,'player_shoot_sound')
	player_node.connect('player_fires', mothership_container_node, 'increase_counter')
	player_node.connect('player_hit', self,'player_hit')
	player_node.connect('player_explosion_complete', self, 'player_explosion_complete')
	player_node.connect('demo_ended', self,'demo_ended')
	player_node.connect('demo_ended', mothership_container_node,'pause_timer')
	player_node.connect('demo_ended', hud_node,'demo_ended')
	
	invader_controller_node.connect('hit',sound_node,'invader_explode_sound')
	invader_controller_node.connect('score_add',scoreboard_node,'add_score')
	invader_controller_node.connect('cleared_level', self, 'cleared_level')	
	invader_controller_node.connect('cleared_level', sound_node, 'disable_move_sound')
	invader_controller_node.connect('invaders_spawned',sound_node,'enable_move_sound')
	invader_controller_node.connect('invaders_spawned',mothership_container_node,'start_timer')	
	invader_controller_node.connect('invaders_did_land',self,'landed')
	invader_controller_node.connect('invaders_did_land',sound_node,'disable_move_sound')
	invader_controller_node.connect('invaders_did_land',sound_node,'play_player_explode_sound')	
	invader_controller_node.connect('invaders_spawned',player_node,'start')
	invader_controller_node.connect('invaders_spawned',bomb_controller_node,'start_bombs')
	mothership_container_node.connect('mothership_spawn',sound_node,'play_mothership_sound')
	mothership_container_node.connect('mothership_screen_exit',sound_node,'stop_mothership_sound')
	mothership_container_node.connect('mothership_hit',sound_node,'play_mothership_bonus_sound')
	mothership_container_node.connect('score_add',scoreboard_node,'add_score')
	scoreboard_node.connect('score_updated',bomb_controller_node, 'score_updated') # bomb controller receives score and chnages reload rate
	scoreboard_node.connect('extra_life',sound_node, 'player_extra_life_sound')
	scoreboard_node.connect('extra_life',self, 'extra_life')

	$"Background".visible = true
	$"Background/foreground".material.set_shader_param("cutoff", 0)
	
	if demo_mode == false:
		$Shield_container.visible = false
		$"Scoreboard".pulse_score()
		yield(get_tree().create_timer(3),"timeout")
		
	get_ready_text.visible = false
	$Shield_container.visible = true # start set visible
	invader_controller_node.spawn_invaders()


# via signal - stop invaders moving / dropping bombs
func player_hit():
	if is_game_over != true:
		get_tree().call_group('invader','disable_moving')
	
# via signal
func player_explosion_complete():
	if is_game_over != true:
		lives -=1
		if lives<0:
			lives = 0
		hud_node.show_lives(lives)
		if lives <=0 and is_game_over == false:
			game_over()
		else:
			player_node.reset_base()
			get_tree().call_group('invader','enable_moving')

# via signal
func extra_life():
	lives += 1
	hud_node.show_lives(lives)
	

func _process(_delta):
	# fire key will exit demo 
	if demo_mode == true and Input.is_action_pressed("fire"):
		demo_ended()
	
# signal from invader_container	
func cleared_level():
	player_node.hide_base()
	yield(get_tree().create_timer(3),"timeout")
	baseline_node.reset()
	shield_container_node.reset()
	invader_controller_node.next_level()
			
# via signal			
func demo_ended():
	demo_mode = false
	is_game_over = true
	$"Background/AnimationPlayer".play("wipe")
	yield(get_tree().create_timer(1),"timeout") #small delay to wipe transition
	return_to_intro()	
	
# signal from invader_container		
func landed():
	is_game_over = true
	get_node("Player").explode()
	lives = 0
	hud_node.show_lives(lives)
	yield(get_tree().create_timer(2),"timeout") #small delay
	game_over()
	
func game_over():
	if is_game_over == false:
		is_game_over = true
		emit_signal("game_ended")
		#update hiscore if needed
		$"Scoreboard".final_score()	
		$"AnimationPlayer".play("game_over_text")
		yield(get_tree().create_timer(3),"timeout")
		$"Background/AnimationPlayer".play("wipe")
		yield(get_tree().create_timer(1),"timeout") #small delay to wipe transition
		return_to_intro()
	else:
		return_to_intro()	
	
func return_to_intro():		
	if get_tree().change_scene("res://scenes/intro.tscn")!= OK:
		print('bad scene change')


