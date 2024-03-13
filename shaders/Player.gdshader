shader_type canvas_item;
// Change panty color depending on depression.
// This also hase a very cool consuming effect, might do something with that.
uniform vec4 panty_base_color : source_color;
uniform float area : hint_range(0.0, 1.0);
uniform vec4 dark_color : source_color;
uniform float darkening_factor : hint_range(0.0, 1.0);

// Function to compare colors
bool is_color(vec4 col1, vec4 col2) {
    return all(lessThan(abs(col1.rgb - col2.rgb), vec3(area)));
}

void fragment() {
	vec4 original_color =  texture(TEXTURE, UV);
	
	if (original_color.a == 1.0 && is_color(original_color, panty_base_color)) {
		vec4 new_color = dark_color + vec4(original_color.rgb - panty_base_color.rgb, 1.0);
        original_color = mix(original_color, new_color, darkening_factor);
    }
	
	COLOR = original_color;
}

