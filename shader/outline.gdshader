shader_type canvas_item;
uniform bool selected = false;
uniform vec4 outline_color: source_color = vec4(1.0);
uniform float outline_size = 10.0;
void fragment(){
	vec4 color = texture(TEXTURE, UV);
	vec2 px = TEXTURE_PIXEL_SIZE * outline_size;
	float outline = 0.0;
	outline += texture(TEXTURE, UV + vec2(px.x,0.0)).a;
	outline += texture(TEXTURE, UV - vec2(px.x,0.0)).a;
	outline += texture(TEXTURE, UV + vec2(0.0,px.y)).a;
	outline += texture(TEXTURE, UV - vec2(0.0,px.y)).a;
	outline += texture(TEXTURE, UV + vec2(px.x, px.y)).a;
	outline += texture(TEXTURE, UV + vec2(-px.x, px.y)).a;
	outline += texture(TEXTURE, UV + vec2(px.x, -px.y)).a;
	outline += texture(TEXTURE, UV + vec2(-px.x, -px.y)).a;
	if(selected && color.a == 0.0 && outline > 0.0){
		COLOR = outline_color;
	}else{
		COLOR = color;
	}
}