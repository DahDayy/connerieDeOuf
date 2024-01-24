#pragma once
#include <string>
#include <unordered_map>
#include "Vendor/glm/glm.hpp"


struct ShaderProgramSource
{
	std::string VertexSource;
	std::string FragmentSource;
};
class Shader
{
private:
	std::string m_Filepath;
	unsigned int m_RendererId;
	std::unordered_map<std::string, int> m_UniformLocationCache;
public:
	Shader(const std::string& filepath);
	~Shader();

	void Bind() const;
	void Unbind() const;

	// set uniforms
	void SetUniform4f(const std::string& name, float v0, float v1, float v2, float v3);
	void SetUniform1f(const std::string& name, float value);
	void SetUniform1i(const std::string& name, int value);
	void SetUniformMat4f(const std::string& name, const glm::mat4& matrix);
private:

	ShaderProgramSource ParseShader(const std::string& filepath);

	unsigned int CompileShader(unsigned int type, const std::string& source);

	unsigned int createShader(const std::string& vertexShader, const std::string& fragmentShader);

	unsigned int GetUniformLocation(const std::string& name);
};