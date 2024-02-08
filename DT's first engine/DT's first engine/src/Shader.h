#pragma once

#include <string>
#include <fstream>
#include <sstream>
#include <iostream>

#include "ErrorManager.h"

class Shader {
public:
	unsigned int id;

	Shader(const char* vertPath, const char* fragPath);
	~Shader();

	void use();
	
	void setBool(const std::string &name, bool value) const;
	void set1Float(const std::string& name, float value) const;
	void set3Float(const std::string& name, float r, float g, float b) const;
	void set4Float(const std::string& name, float r, float g, float b, float a) const;
	void setInt(const std::string& name, int value) const;
	void setmat4fv(const std::string& name, const glm::mat4 matrix) const;
	void set3Vec(const std::string& name, const glm::vec3 vec) const;
};