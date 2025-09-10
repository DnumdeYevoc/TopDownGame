shader_type canvas_item; 

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

    vec4 original_color = texture(TEXTURE, UV); // Get the original color
    COLOR = original_color * 1.05; // Multiply by the darkening factor

	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
