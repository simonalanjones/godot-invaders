extends Area2D
var timer
var height

var status = true
export (int) var missile_speed = 5
var player_shot_explodes = preload("res://sprites/player/player-shot-explodes-texture.png")

func _ready():
	height = $Sprite.get_texture().get_height()
	
func _process(_delta):
	$"Sprite".material.set_shader_param("world_y", position.y)
	$"Sprite".material.set_shader_param("height", height)
	
	if status == true:
		if position.y>33:
			position.y = position.y - missile_speed
		else:
			explode()
	
func _on_Missile_area_entered(area):
	if area.is_in_group('invader'):
		status = false
		self.modulate.a = 0.0
		pause_and_remove(.4)
		
	if area.is_in_group('bomb'):
		status=false
		get_node("Sprite").set_texture(player_shot_explodes)
		pause_and_remove(.4)
		
func explode(wait=0.3):
	status = false
	get_node("Sprite").position.x -=4
	#get_node("Sprite").position.y +=5
	get_node("Sprite").set_texture(player_shot_explodes)
	pause_and_remove(wait)
	
func pause_and_remove(n):
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(n)
	timer.connect('timeout',self,'remove_from_scene')
	timer.start()
	add_child(timer)
	
func remove_from_scene():
	queue_free()