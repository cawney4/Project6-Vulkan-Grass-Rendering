#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
layout(location = 0) in vec4 v0[];
layout(location = 1) in vec4 v1[];
layout(location = 2) in vec4 v2[];
layout(location = 3) in vec4 up[];

layout(location = 0) out vec4 pos;
layout(location = 1) out vec3 nor;
layout(location = 2) out float fs_v;

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
	fs_v = v;

	float angle = v0[0].w;
	float height = v1[0].w;
	float width = v2[0].w;

	vec3 t1 = vec3(cos(angle), 0, sin(angle));
	vec3 a = v0[0].xyz + v * (v1[0].xyz - v0[0].xyz);
	vec3 b = v1[0].xyz + v * (v2[0].xyz - v1[0].xyz);
	vec3 c = a + v * (b - a);
	vec3 c0 = c - width * t1;
	vec3 c1 = c + width * t1;
	vec3 t0 = b - a;
	t0 = normalize(t0);
	nor = normalize(cross(vec3(t0), vec3(t1)));

	float tau = 0.75;
	float t = 0.5 + (u - 0.5) * (1 - (max(v - tau, 0)/(1 - tau)));

	vec3 p = (1 - t) * c0 + t * c1;
	pos = vec4(p, 1);
	gl_Position = camera.proj * camera.view * pos;
}
