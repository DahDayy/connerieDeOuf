#version 400

layout (location = 0) in vec3 positionzz;

layout (location = 1) in vec3 nposition;

layout (location = 2) in vec2 texCoord;

uniform mat4 Model;
uniform mat4 View;
uniform mat4 Projection;

out vec3 fragPos;
out vec3 normal;
out vec2 texPos;


void main() 
{
	fragPos = vec3(Model * vec4(positionzz, 1.0));
	gl_Position = Projection * View * vec4(fragPos, 1.0);
	normal = mat3(transpose(inverse(Model))) * nposition; 
	texPos = texCoord;
};