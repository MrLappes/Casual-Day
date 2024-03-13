shader_type canvas_item;
/*
This is a shader created to have the same image at darkening_factor 0,
and a darker image at 1.0 that interpolates smoothly. Simple but efficient.
Used to make the girl hide in the background after the robber pulls our his gun.
*/
uniform float darkening_factor : hint_range(0.0, 1.0);
uniform vec3 hidden_color;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    vec4 dark_color = vec4(hidden_color, original_color.a);
    vec4 final_color = mix(original_color, dark_color, darkening_factor);
    COLOR = final_color;
}
