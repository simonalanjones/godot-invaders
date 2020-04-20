extends Node2D

var array = []

func _ready():
	pass
	#self.connect("bomb_grounded", self, "_on_bomb_grounded")

func _draw():
	draw_line(Vector2(0,240), Vector2(224, 240), Color(0, 255, 0),1 )
	for d in array:
		draw_line(Vector2(d,240), Vector2(d+1, 240), Color(0, 0, 0),1 )
		
func take_damage(x_position):
	array.append(x_position)
	update()
	
func reset():
	array = []
	update()