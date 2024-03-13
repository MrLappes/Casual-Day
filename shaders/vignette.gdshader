shader_type canvas_item;
// Basic shader to create vignette effect on camera.
// No idea if this is how you do it, just playing around.
uniform float intensity : hint_range(0.3,5.0) = 0.5;

void fragment() {
    float dist = distance(UV, vec2(0.5, 0.5));
    float vignette = smoothstep(0.8, 1.0 - intensity, dist);
	COLOR = vec4(0.0,0.0,0.0,1.0-vignette);
}
