#version 400

in vec3 TexCoords;

out vec4 fragColour;

uniform sampler2D texture_diffuse1;

void main()
{
	fragColour = texture(texture_diffuse, TexCoords);
}