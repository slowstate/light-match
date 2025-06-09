shader_type canvas_item;

uniform float timer_progress: hint_range(0.0, 1.0);
uniform vec4 modulation: source_color;

const float TWO_PI = 6.28318530718;

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));

	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

void vertex() {
	// Called for every vertex the material is visible on.
	//UV = UV + vec2(1.0, 0.0) * TIME;
}

void fragment() {
	// Called for every pixel the material is visible on.
	//vec2 translate = vec2(UV.x, UV.y - timer_progress*0.5);
	vec2 rotate = rotate(UV, vec2(0.5, 0.25 + 0.35*timer_progress), -timer_progress*0.5+PI/2.0);
	//COLOR += translate;
	COLOR = texture(TEXTURE, vec2(rotate.x, rotate.y - timer_progress*0.35)) * modulation;//textureLod(image_texture, UV + vec2(cos(TIME), sin(TIME * 2.0)) * 0.1, 0.0);//vec2(cos(TIME), sin(TIME * 2.0)) * 0.2);
	COLOR.a = COLOR.a * (1.0-timer_progress);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
