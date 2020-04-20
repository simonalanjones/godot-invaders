extends Area2D

var row = 0
var height
var width

var frame_pointer = 0
var status = true
signal invader_hit

var invader_explode_frame = preload("res://sprites/invader/invader-explode.png")

var small_invader_frames = [
	preload("res://sprites/invader/invader-small-frame1.png"),
	preload("res://sprites/invader/invader-small-frame2.png")
	]

var mid_invader_frames = [
	preload("res://sprites/invader/invader-mid-frame1.png"),
	preload("res://sprites/invader/invader-mid-frame2.png")
	]
	
var large_invader_frames = [
	preload("res://sprites/invader/invader-large-frame1.png"),
	preload("res://sprites/invader/invader-large-frame2.png")
	]


func _ready():
	$Sprite.set_texture(get_texture())
	height = $Sprite.get_texture().get_height()
	width = $Sprite.get_texture().get_width()
	add_to_group('invader')
	status = false

func _process(_delta):
	$Sprite.material.set_shader_param("world_y", position.y)
	$Sprite.material.set_shader_param("height", height)
	
func enable_moving():
	status = true
	
func disable_moving():
	status = false
	
func get_score_amount():
	match row:
		0: return 10
		1: return 10
		2: return 20
		3: return 20
		4: return 30
		_: return 30
				
func set_row(number):
	row = number

func get_lauch_vector():
	var launch = $Launch_position
	var x = launch.global_position.x
	var y = launch.global_position.y
	return Vector2(x,y)
				
func has_clear_path():	
	if $Ray_down.is_colliding() and $Ray_down.get_collider().is_in_group('invader'):	
		return false
	else:
		return true
	
func get_sprite_frames():
	match row:
		4: return small_invader_frames
		3: return mid_invader_frames
		2: return mid_invader_frames
		1: return large_invader_frames
		0: return large_invader_frames
		_: return large_invader_frames
			
func get_texture():
	var frames = get_sprite_frames()
	if frame_pointer == 0:
		frame_pointer = 1
	else:
		frame_pointer = 0
	return frames[frame_pointer]

func move(direction):
	if status == true:
		$Sprite.set_texture(get_texture())
		position.x += direction

func move_down(direction):
	if status == true:
		$Sprite.set_texture(get_texture())
		position.y += direction
		
func get_status():
	return status
	
func has_landed() -> bool:
	if global_position.y+height >= 218:
		return true
	else:
		return false
	
func _on_Invader_area_entered(area):
	if area.get_name() == 'Missile':
		area.position.x = 999
		area.position.y = 999
		area.status = false
		
		emit_signal("invader_hit", area, get_score_amount(),get_index())
		$Sprite.set_texture(invader_explode_frame)
		status = false
		var timer = Timer.new()
		timer.set_one_shot(true)
		timer.set_wait_time(.3)
		timer.connect('timeout',self,'remove_invader')
		timer.start()
		add_child(timer)
		
func remove_invader():
		queue_free()