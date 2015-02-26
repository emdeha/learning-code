#include "Pen.h"

#include <iostream>


void Pen::DrawLine(int startX, int startY, int endX, int endY)
{
	if (isDown)
	{
		std::printf("Drawing \'%c\' from (%i, %i) to (%i, %i) with %i color\n", 
			symbol, startX, startY, endX, endY, color);
	}
	else
	{
		std::cout<< "Logic Error: Pen is not down\n";
	}
}