#version 400

struct Material {
    sampler2D diffuse;
    sampler2D specular;
    float shininess;
	sampler2D emissionMap;
}; 
struct DirLight {
    vec3 direction;
  
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};  
struct PointLight {
    vec3 position;
    
    float constant;
    float linear;
    float quadratic;
	
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

struct SpotLight {
    vec3 position;
    vec3 direction;
    float cutOff;
    float outerCutOff;
  
    float constant;
    float linear;
    float quadratic;
  
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;       
};

in vec3 normal;
in vec3 fragPos;
in vec2 texPos;

out vec4 frag_colour;

uniform vec3 viewPos;
uniform Material material;
uniform DirLight dirLight;
#define NR_POINT_LIGHTS 4
uniform PointLight pLights[NR_POINT_LIGHTS];
uniform SpotLight spotLight;

uniform float time;
// function prototypes
vec3 calcDirLight(DirLight light, vec3 normal, vec3 viewDir);
vec3 calcPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir);
vec3 calcSpotLight(SpotLight light, vec3 normal, vec3 fragPos, vec3 viewDir);

vec3 calcDirLight(DirLight light, vec3 norm, vec3 viewDir){

	vec3 lightDir = normalize(-light.direction);
	//diffuse shading
	float diff = max(dot(norm, lightDir), 0.0);
	//specular shading
	vec3 reflectDir = reflect(-lightDir, norm);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
	//combine results
	vec3 ambient = texture(material.diffuse, texPos).rgb * light.ambient;
	vec3 diffuse = light.diffuse * diff * texture(material.diffuse,texPos).rgb;
	vec3 specular = texture(material.specular, texPos).rgb * spec * light.specular;  
	return (ambient + diffuse + specular);
}

vec3 calcPointLight(PointLight light, vec3 norm, vec3 fragpos, vec3 viewDir)
{
	vec3 lightDir = normalize(light.position - fragPos);
	//diffuse shading
	float diff = max(dot(norm, lightDir), 0.0);
	//specular shading
	vec3 reflectDir = reflect(-lightDir, norm);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
	// attenuation
    float distance    = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + 
  						light.quadratic * (distance * distance));   
	//combining results
	vec3 ambient = texture(material.diffuse, texPos).rgb * light.ambient;
	vec3 diffuse = light.diffuse * diff * texture(material.diffuse,texPos).rgb;
	vec3 specular = texture(material.specular, texPos).rgb * spec * light.specular; 
	ambient *= attenuation;
	diffuse *= attenuation;
	specular *= attenuation;
	return(ambient + diffuse + specular);
}
vec3 calcSpotLight(SpotLight light, vec3 norm, vec3 fragPos, vec3 viewDir){

	vec3 lightDir = normalize(light.position - fragPos);
	//diffuse shading
	float diff = max(dot(norm, lightDir), 0.0);
	//specular shading
	vec3 reflectDir = reflect(-lightDir, norm);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
	// attenuation
    float distance    = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + 
  						light.quadratic * (distance * distance));  
	//intensity
	float theta = dot(lightDir, normalize(-light.direction));
	float epsilon   = light.cutOff - light.outerCutOff;
	float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);   

	//combining results
	vec3 ambient = texture(material.diffuse, texPos).rgb * light.ambient;
	vec3 diffuse = light.diffuse * diff * texture(material.diffuse,texPos).rgb;
	vec3 specular = texture(material.specular, texPos).rgb * spec * light.specular; 

	ambient *= attenuation *intensity;
	diffuse *= attenuation * intensity;
	specular *= attenuation * intensity;
	return(ambient + diffuse + specular);
}
void main()
{
	vec3 norm = normalize(normal);
	vec3 viewDir = normalize(viewPos - fragPos);
	vec3 emission = vec3(0.0f);

	if(texture(material.specular, texPos).r == 0.0f){
		emission = texture(material.emissionMap, texPos).rgb;
		//some extra fun stuff with "time uniform"
        emission = texture(material.emissionMap, texPos + vec2(0.0,time)).rgb;
        emission = emission * (sin(time) * 0.5 + 0.5) * 2.0;   
	}
	//phase 1: direction light + emission
	vec3 result = calcDirLight(dirLight, norm, viewDir) + emission;
	//phase 2: point light
	for(int i = 0; i<NR_POINT_LIGHTS; i++)
		result += calcPointLight(pLights[i], norm, fragPos, viewDir);
	//phase 3: spot light
	result += calcSpotLight(spotLight, norm, fragPos, viewDir);

	frag_colour = vec4(result, 1.0);

};