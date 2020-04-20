extends Sprite

func _ready():
	self.material.set_shader_param("world_y", position.y)
	self.material.set_shader_param("height", get_texture().get_height())