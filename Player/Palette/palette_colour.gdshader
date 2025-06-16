shader_type canvas_item;

uniform float random_number: hint_range(-1.0, 1.0);
uniform float timer_progress: hint_range(0.0, 1.0);
uniform vec4 modulation: source_color;
uniform float alpha: hint_range(0.0, 1.0);

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
	vec2 rotate = rotate(UV, vec2(0.5, 1.0/6.0 + 0.5*timer_progress), random_number * timer_progress*0.5+PI/2.0);

	COLOR = texture(TEXTURE, vec2(rotate.x, rotate.y - timer_progress*0.5)) * modulation;
	COLOR.a = COLOR.a * alpha * (1.0-timer_progress);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
