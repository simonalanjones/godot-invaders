shader_type canvas_item;
uniform int world_y;
uniform int height;


void fragment(){
	vec4 col = texture(TEXTURE,UV);
	COLOR = texture(TEXTURE, UV);
	float shader_y = UV.y * float(height) + float(world_y);	
	
	// top section
	//if (float(shader_y) < float(cutoff))
	if (float(shader_y) < 190.0)
	{
		if (COLOR.a != 0.0) 
		{
			COLOR = vec4(255.0, 255.0, 255.0, COLOR.a);
		}
	} 
	else 
	{
		// lower section
		if (COLOR.a != 0.0) 
		{
			COLOR = vec4(0.0, 255.0, 0.0, COLOR.a);
		}
	}
	
}