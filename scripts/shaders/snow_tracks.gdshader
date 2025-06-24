shader_type spatial;
uniform sampler2D viewport_texture;
uniform vec3 base_color: source_color;
uniform vec3 deep_color: source_color;
uniform float snow_height;

void vertex() {
	//float downness = texture(viewport_texture, UV).g;
	//VERTEX.y += downness;
	VERTEX.y = snow_height - texture(viewport_texture, -UV).r * snow_height;
}

void fragment() {
	// Called for every pixel the material is visible on.
	float mask = texture(viewport_texture, -UV).r;
	ALBEDO = mix(base_color, deep_color, mask);

}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
