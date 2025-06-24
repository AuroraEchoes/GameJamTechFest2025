shader_type spatial;
uniform sampler2D noise;
uniform float noise_strength = 2.0f;
uniform sampler2D color_noise;
uniform int number_bands;
uniform float rotation_degrees = 45.0f;
uniform vec3 color_a : source_color;
uniform vec3 color_b : source_color;
varying vec3 vertex_color;

float noise_sample(vec3 vertex)
{
	float rotation = radians(radians(rotation_degrees));
	mat2 rot_matrix = mat2(vec2(cos(rotation), sin(rotation)), vec2(-sin(rotation), cos(rotation)));
	vec2 rotated_pos = vec2(vertex.x, vertex.z) * rot_matrix;
	return texture(noise, rotated_pos).x * noise_strength;
}

void vertex() {
	VERTEX.y += noise_sample(VERTEX);
	//vec3 unbanded = mix(color_a, color_b, texture(color_noise, UV).x);
	float bands = floor(float(number_bands) * texture(color_noise, UV).x) / float(number_bands);
	vertex_color = mix(color_a, color_b, bands);
	//vertex_color = color_a;
}

void fragment() {
	// From u/lithium, https://www.reddit.com/r/opengl/comments/13sgj82/best_way_to_calculate_normals_of_a_changing_mesh/
	vec3 a = dFdx(VERTEX);
	vec3 b = dFdy(VERTEX);
	vec3 normal = normalize (cross(a, b));
	NORMAL = normal;
	ALBEDO = vertex_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
