#pragma once

#include "Test.h"

class TestShape
{
public:
	TestShape();
	~TestShape();

	void onUpdate(float time);
	void onRender();
	void onImGuiRender();
};