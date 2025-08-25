shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


// --- Uniforms --- //
uniform bool weighted = true;	// Determines whether to use normal or weighted averages

void fragment() {
	vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
	COLOR.rgb = mix(vec3((c.r + c.g + c.b) / 3.0),  vec3(0.299 * c.r + 0.587 * c.g + 0.114 * c.b), float(weighted));
}