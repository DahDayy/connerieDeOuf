#pragma once

#include "Test.h"

namespace test {
	class TestClearColor : public Test
	{
	public:
		TestClearColor();
		~TestClearColor();

		void onUpdate(float deltaTime);
		void onRender();
		void onImGuiRender();
	private:
		float m_ClearColor[4];
	};
}