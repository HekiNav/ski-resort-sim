shader_type spatial;

uniform float height = 64.0;
uniform float size = 128.0;
uniform sampler2D color_gradient;
uniform sampler2D normal_map;
uniform sampler2D path_texture;


void fragment() {
	vec4 world_vertex = INV_VIEW_MATRIX * vec4(VERTEX,1.0);
	vec3 model_vertex = (inverse(MODEL_MATRIX) * world_vertex).xyz;
	float gradient_uv = (model_vertex.y / height) + 0.5;
	vec4 pathColor = texture(path_texture, vec2((model_vertex.x+size*0.5)/size, (model_vertex.z+size*0.5)/size)).rgba;
	vec3 baseColor = texture(color_gradient, vec2(gradient_uv)).rgb;

	ALBEDO = baseColor * (1.0 - pathColor.a) + pathColor.rgb * pathColor.a;
	NORMAL_MAP = texture(normal_map, UV).xyz;
}
