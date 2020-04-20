extends Node2D


onready var demo_mode = false
onready var lives_label = $"HUD/Lives_label"
onready var demo_text = $"HUD/Demo_text"
onready var demo_flash_counter = 0

func _ready():
	
	# this is set by scene switcher function 
	demo_mode = Scene_switcher.get_param("demo_mode")			
	demo_text.visible = true if demo_mode == true else false
	if demo_mode == true:
		$"HUD/Base_image1".visible = false
		$"HUD/Base_image2".visible = false
		$"HUD/Base_image3".visible = false
		lives_label.visible = false
	else:
		show_lives()

func demo_ended():
	demo_mode = false
	demo_text.visible = false
			
func _process(_delta):
	if demo_mode == true:
		# flashing attract mode text
		demo_flash_counter +=1
		if demo_flash_counter>30:
			demo_flash_counter = 0;
			demo_text.visible = !demo_text.visible

func show_lives(lives=3):
	lives_label.text = str(lives)
	match lives:
			0,1: 
				$"HUD/Base_image1".visible = false
				$"HUD/Base_image2".visible = false
				$"HUD/Base_image3".visible = false
			2:
				$"HUD/Base_image1".visible = true
				$"HUD/Base_image2".visible = false
				$"HUD/Base_image3".visible = false
			3:
				$"HUD/Base_image1".visible = true
				$"HUD/Base_image2".visible = true
				$"HUD/Base_image3".visible = false
			4:
				$"HUD/Base_image1".visible = true
				$"HUD/Base_image2".visible = true
				$"HUD/Base_image3".visible = true