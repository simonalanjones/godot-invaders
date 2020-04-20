extends Area2D

var shield_top_y
var shield_bottom_y
var shield_left_x
var shield_height

var shield_sprite

var shield_texture = preload("res://sprites/player/player-shield.png")
var alien_shot_plunger = preload("res://sprites/invader-fire/invader-fire-plunger-mask.png")
var alien_shot = preload("res://sprites/alien-shot-mask.png")
var myimage_mask_plunger = preload("res://sprites/invader-fire/invader-fire-plunger-frame1-mask.png")
var myimage_mask = preload("res://sprites/alien-shot-exploding-mask.png")
var invader_empty_frame = preload("res://sprites/invader/invader-empty-frame.png");

func _ready():
	
	$Sprite.texture = shield_texture
	shield_sprite = $"Sprite"
	$"Sprite".material.set_shader_param("world_y", position.y)
	$"Sprite".material.set_shader_param("height", $"Sprite".get_texture().get_height())
	
	shield_top_y = $"Sprite".global_position.y
	shield_bottom_y = $"Sprite".global_position.y + $"Sprite".get_texture().get_height()
	shield_left_x = $"Sprite".global_position.x
	shield_height = $"Sprite".get_texture().get_height()
	
	
	

# we call this as we need to continually poll the shield for overlaps
# on_Area2D_area_entered only fires once
# put this on a timer function every .3 to reduce the number of times polled
# shield scene has a timer attached
func _on_Timer_timeout():
	var areas = get_overlapping_areas()
	if areas.size() > 0:
		
		for area in areas:
			
			var index_found
					
			if area.is_in_group('invader'):
				damage_shield_from_invader(area)
			
			if area.name == 'Missile' and area.status == true:
				
				# get the pixel row from the base of shield that collision happended 
				# 16 = bottom of shield, 0 = top of shield
				index_found = has_missile_collision(area)

				# -1 indicates no pixels detected on this frame of overlap test
				if index_found != -1 and area.status == true:
					
					# make a copy of the missile vector before we destroy it
					var mpos = Vector2(area.position.x,area.position.y)
					#area.explode(.2)

					area.status = false
					area.queue_free()
					damage_shield_from_missile(mpos,index_found)

			if area.is_in_group('bomb'):

				# get the pixel row from the top of shield that collision happended
				index_found = has_bomb_collision(area)
				if index_found != -1 and area.status == true:
					var mpos = Vector2(area.position.x,index_found)
					var type = area.type
					area.explode(.2)
					var timer = Timer.new()
					timer.set_one_shot(true)
					timer.set_wait_time(.2)
					timer.connect('timeout',self,'damage_shield_from_bomb',[mpos,type])
					timer.start()
					add_child(timer)
		


func damage_shield_from_missile(mpos, index_found):
	
	var vec2_missile = to_local(mpos)
	vec2_missile.y = index_found-5
	
	var player_shot = preload("res://sprites/player/player-shot-mask.png")
	var myimage_mask = preload("res://sprites/player/player-shot-explodes-mask.png")
	
	var src_rect = Rect2(0,0,8,8)
	var dst = vec2_missile
	dst.x -=3
		
	# the shield sprite texture
	var shield_data = shield_sprite.get_texture().get_data()
	# lock the texture before reading it
	shield_data.lock()
	shield_data.blit_rect_mask (player_shot, myimage_mask, src_rect, dst)
	var texture = ImageTexture.new()
	texture.create_from_image(shield_data,0)
	shield_sprite.set_texture(texture)
	
func has_missile_collision(area):
	
	#get a local vector within the shield
	var vec2_missile = to_local(area.position)
	var missile_x = abs(vec2_missile.x) # 0-23
	var missile_y = round(vec2_missile.y) # 0-16
	
	var shield_data = shield_sprite.get_texture().get_data() #image returned
	shield_data.lock()
	
	#create a Rect 1 pixel wide by height of shield
	var shield_read_rect = Rect2(missile_x,0,1,shield_height)
	
	# get the shield data defined by rect shape
	var sample_image = shield_data.get_rect(shield_read_rect) # returns image
	sample_image.lock() # this is the image we read from to check for collision
		
	# build an array (1px slice) of the shield aligned with x position of missile
	var pixel_array = []
	for r in range(shield_height):
		var pixel = sample_image.get_pixel ( 0, r )
		pixel_array.append(pixel.a8)

	# array contains alpha values of pixels from top to bottom of slice (0-15)
	# reverse array so look-up will start from bottom of slice
	pixel_array.invert()

	var index_found = pixel_array.find(255) # -1 indicates not found, 0 indicates bottom of shield
	if index_found != -1:
		var row_found = 16-index_found

		if missile_y <= row_found:
			return row_found
		else:
			return -1
	else:		
		return -1



func damage_shield_from_invader(area):
	var vec2_invader = to_local(area.position)
	var invader_x = vec2_invader.x
	var invader_y = vec2_invader.y
		
	var shield_data = shield_sprite.get_texture().get_data() #image returned
	shield_data.lock()
	
	var src_rect = Rect2(0,0,16,8)
	var dst = Vector2(invader_x,invader_y)
	
	shield_data.blit_rect (invader_empty_frame, src_rect, dst)
	
	var texture = ImageTexture.new()
	texture.create_from_image(shield_data,0)
	shield_sprite.set_texture(texture)
	

func has_bomb_collision(area):
	var vec2_bomb = to_local(area.position)
	var bomb_x = abs(vec2_bomb.x)
	var bomb_y = round((vec2_bomb.y))+1
	
	var shield_data = shield_sprite.get_texture().get_data() #image returned
	shield_data.lock()
	
	#create a Rect 3 pixel wide by height of shield
	var shield_read_rect = Rect2(bomb_x,0,3,shield_height)
	
	# get the shield data defined by rect shape
	var sample_image = shield_data.get_rect(shield_read_rect) # returns image
	sample_image.lock() # this is the image we read from to check for collision
		
	var pixel_array = []
	for r in range(shield_height):

		var pixel = sample_image.get_pixel(0,r)
		pixel_array.append(pixel.a8)

		var pixel1 = sample_image.get_pixel(1,r)
		pixel_array.append(pixel1.a8)
		
		var pixel2 = sample_image.get_pixel(2,r)
		pixel_array.append(pixel2.a8)
						
	#255 if the alpha channel stored of each pixel
	var index_found = pixel_array.find(255) # -1 indicates not found

	if index_found != -1: #and bomb_y > index_found:
	
		# as we store 3 pixels for each row, we need to divide by 3 to get row number (from top)
		index_found = index_found/3 #index_found is now the row from the top which has shield sprite data
		
		# this makes the lower part of the shield dissolve slower
		if bomb_y >= index_found-2:
			return index_found
		else:
			return -1
		
	return index_found

func damage_shield_from_bomb(mpos,type):
		
	var vec2_bomb = to_local(mpos)	
	vec2_bomb.y = mpos.y
	
	# 6,8 is size of source explosion shot which gets copied
	var src_rect = Rect2(0,0,6,8)
	var dst
	var dst2
	#plunger goes slightly deeper

	if type == 1:
		dst = Vector2(vec2_bomb.x,vec2_bomb.y)
		dst2 = Vector2(vec2_bomb.x-2,vec2_bomb.y)
		blit_texture(alien_shot_plunger,myimage_mask_plunger,src_rect,dst)
		blit_texture(alien_shot,myimage_mask,src_rect,dst2)
	else:
		dst = Vector2(vec2_bomb.x-2,vec2_bomb.y-3)
		blit_texture(alien_shot,myimage_mask,src_rect,dst)
	

func blit_texture(image,mask, src_rect, dst):
	if image.get_width() != mask.get_width():
		
		print('bad width')
		print(image.get_width())
		print(mask.get_width())
		print('-----')
	# the shield sprite texture
	var shield_data = shield_sprite.get_texture().get_data()
	# lock the texture before reading it
	shield_data.lock()
	shield_data.blit_rect_mask (image, mask, src_rect, dst)
	var texture = ImageTexture.new()
	texture.create_from_image(shield_data,0)
	shield_sprite.set_texture(texture)
	
func reset():
	$Sprite.texture = shield_texture