shader_type canvas_item;

uniform float scale = 0.5;

float noise(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec2 d = vec2(0.5, 0.5) - SCREEN_UV;
	d *= d;

	float fade = smoothstep(0.0, 0.9, (d.x + d.y)) * 4.0;
	
	float vignette = fade * scale;
	float dithered = vignette + (noise(SCREEN_UV) * 0.05);

	COLOR.rgb = vec3(0.104, 0.048, 0.16);
	COLOR.a = clamp(dithered, 0.0, 1.0);
}
