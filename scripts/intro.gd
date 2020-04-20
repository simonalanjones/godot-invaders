extends Node2D

onready var play_text = $"text-holder/play_text"
onready var get_ready_text = $"text-holder/Get_ready_text"
onready var space_invaders_text = $"text-holder/space_invaders_text"
onready var mystery_text_left = $"text-holder/mystery_text_left"
onready var mystery_text_right = $"text-holder/mystery_text_right"
onready var points_30_text_left = $"text-holder/30_points_text_left"
onready var points_30_text_right = $"text-holder/30_points_text_right"
onready var points_20_text_left = $"text-holder/20_points_text_left"
onready var points_20_text_right = $"text-holder/20_points_text_right"
onready var points_10_text_left = $"text-holder/10_points_text_left"
onready var points_10_text_right = $"text-holder/10_points_text_right"
onready var score_advance_text = $"text-holder/score_advance_text"
onready var invader_sprites = $"invader-sprites"

func _init():
	pass
		
func _ready():
	play_text.visible_characters = 0
	space_invaders_text.visible_characters = 0
	mystery_text_left.visible_characters = 0
	mystery_text_right.visible_characters = 0
	points_30_text_left.visible_characters = 0;
	points_30_text_right.visible_characters = 0;
	points_20_text_left.visible_characters = 0;
	points_20_text_right.visible_characters = 0;
	points_10_text_left.visible_characters = 0;
	points_10_text_right.visible_characters = 0;
	
	score_advance_text.visible = false
	get_ready_text.visible = false
	invader_sprites.visible = false
	$"Background/foreground".material.set_shader_param("cutoff", 0)
	$"AnimationPlayer".play("main_text")

func _input(event):
	if event.is_action_pressed("fire"):
		$"Background/AnimationPlayer".play("wipe")
		#get_ready_text.visible = true
		yield(get_tree().create_timer(.5),"timeout") #small delay for wipe transition
		Scene_switcher.change_scene("res://scenes/Main.tscn", {"demo_mode":false})
		
		
func _on_Timer_timeout():
	# were going to the demo
	Scene_switcher.change_scene("res://scenes/Main.tscn", {"demo_mode":true})
