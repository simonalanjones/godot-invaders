shader_type canvas_item;
uniform float cutoff : hint_range(0.0, 1.0);

void fragment() {
    COLOR = texture(TEXTURE, UV);
	if (UV.x < cutoff) {
		COLOR.a = 1.0;
	}
	else
	{
		COLOR.a = 0.0;	
	}
}