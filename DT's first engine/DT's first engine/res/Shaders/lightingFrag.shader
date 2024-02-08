#version 330

out vec4 fragColour;

struct Light {
    vec3 position;
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

uniform Light light;  

void main()
{
	fragColour = vec4(light.ambient * light.diffuse * light.specular, 1.0);
}