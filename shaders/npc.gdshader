shader_type canvas_item;

// Modified unfocus.gdshader to also change color of character
uniform float darkening_factor : hint_range(0.0, 1.0);
uniform vec3 hidden_color : source_color;

// Define uniforms for each replaceable color
uniform vec4 skin_color : source_color;
uniform vec4 skin_shading_color : source_color;
uniform vec4 hair_color : source_color;
uniform vec4 hair_shading_color : source_color;
uniform vec4 clothes_color : source_color;
uniform vec4 clothes_shading_color : source_color;
uniform vec4 shoes_color : source_color;
uniform vec4 shoes_shading_color : source_color;
uniform vec4 pants_color : source_color;
uniform vec4 pants_shading_color : source_color;

// Function to compare colors
bool is_color(vec4 col1, vec4 col2) {
    return all(lessThan(abs(col1.rgb - col2.rgb), vec3(0.01)));
}

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);

    // Check and replace colors
	if (original_color.a > 0.0) {
		if (is_color(original_color, vec4(0, 1.0, 1.0, 1.0))) {
	        original_color.rgb = skin_color.rgb;
	    } else if (is_color(original_color, vec4(0, 200.0/255.0, 1.0, 1.0))) {
	        original_color.rgb = skin_shading_color.rgb;
	    } else if (is_color(original_color, vec4(1.0, 0, 0, 1.0))) {
	        original_color.rgb = hair_color.rgb;
	    } else if (is_color(original_color, vec4(200.0/255.0, 0, 0, 1.0))) {
	        original_color.rgb = hair_shading_color.rgb;
	    } else if (is_color(original_color, vec4(0, 1.0, 0, 1.0))) {
	        original_color.rgb = clothes_color.rgb;
	    } else if (is_color(original_color, vec4(0, 200.0/255.0, 0, 1.0))) {
	        original_color.rgb = clothes_shading_color.rgb;
	    } else if (is_color(original_color, vec4(1.0, 0, 1.0, 1.0))) {
	        original_color.rgb = shoes_color.rgb;
	    } else if (is_color(original_color, vec4(200.0/255.0, 0, 1.0, 1.0))) {
	        original_color.rgb = shoes_shading_color.rgb;
	    } else if (is_color(original_color, vec4(0, 0, 1.0, 1.0))) {
	        original_color.rgb = pants_color.rgb;
	    } else if (is_color(original_color, vec4(0, 0, 200.0/255.0, 1.0))) {
	        original_color.rgb = pants_shading_color.rgb;
	    }  
	}

    // Apply darkening
    vec4 dark_color = vec4(hidden_color, original_color.a);
    vec4 final_color = mix(original_color, dark_color, darkening_factor);
    COLOR = final_color;
}
