shader_type spatial;
uniform sampler2D noise;
uniform float displacment_strength = 10.0;
uniform int band_count = 5;
uniform vec3 color_a : source_color;
uniform vec3 color_b : source_color;
uniform vec2 subdivisions;
varying vec3 vert;

float sample_at_pos(vec2 pos)
{
	vec2 texture_pos = (pos + vec2(0.5f)) / vec2(textureSize(noise, 0));
	return (texture(noise, texture_pos).x - 0.5) * displacment_strength;
}

vec3 calculate_normal(vec3 vertex, float neighbour_dist)
{
	//vec2 neighbour_dist = vec2(1.0f) / subdivisions;
	vec3 neighbour_one = vertex + vec3(neighbour_dist, 0.0, 0.0);
	vec3 neighbour_two = vertex + vec3(0.0, 0.0, neighbour_dist);
	neighbour_one.y = sample_at_pos(vec2(neighbour_one.x, neighbour_one.z));
	neighbour_two.y = sample_at_pos(vec2(neighbour_two.x, neighbour_two.z));
	return normalize(cross(neighbour_one - vertex, neighbour_two - vertex));
}

void vertex()
{
	float sample = sample_at_pos(vec2(VERTEX.x, VERTEX.z));
	VERTEX.y += sample;
	vert = VERTEX;
}

void fragment()
{
	vec3 interpolated_vert = vec3(vert.x, sample_at_pos(vec2(vert.x, vert.z)), vert.z);
	vec3 normal = calculate_normal(interpolated_vert, 0.01);
	normal = (normal * vec3(1.0, 1.0, -1.0)) / 2.0 + 0.5;
	NORMAL_MAP = vec3(normal.x, normal.z, normal.y);
	float steepness = dot(NORMAL, normalize(VERTEX));
	float blend = floor(texture(noise, UV).x * float(band_count) / float(band_count));
	vec3 color = mix(color_a, color_b, blend);
	ALBEDO = color;
}
