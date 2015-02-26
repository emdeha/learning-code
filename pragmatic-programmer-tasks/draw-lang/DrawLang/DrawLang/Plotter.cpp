#include "Plotter.h"
#include "Utils.h"

#include <string>
#include <iostream>

char Plotter::GetNextCommand(std::string &tokenLine)
{
	std::getline(std::cin, tokenLine);
	tokenLine = Reduce(tokenLine);
	char cmd = tokenLine[0];
	tokenLine.erase(0, 2);

	return cmd;
}

void Plotter::CallCommand(std::pair<char, int> command)
{
	for (auto execFunc = executionMap.begin(); execFunc != executionMap.end(); ++execFunc)
	{
		if (execFunc->first == command.first)
		{
			execFunc->second(command.second);
			return;
		}
	}

	std::printf("Synthax error: No such command - %c\n", command.first);
}

void Plotter::ExecuteCommandQueue()
{
	while (!commandQueue.empty())
	{
		std::pair<char, int> currentCommand = commandQueue.front();
		commandQueue.pop();
		CallCommand(currentCommand);
	}
}


void Plotter::AddPen(int penType, int penColor, char penSymbol)
{
	pens.push_back(std::shared_ptr<Pen>(new Pen(penType, penColor, penSymbol)));
}

void Plotter::AddCommand(char token, std::function<void(int)> executionFunction)
{
	executionMap.push_back(std::make_pair(token, executionFunction));
}

void Plotter::GetCommands()
{
	std::string tokenLine;
	char cmd = GetNextCommand(tokenLine);

	while (cmd != 'r')
	{
		int arg;
		int result = sscanf_s(tokenLine.c_str(), "%i", &arg);
		commandQueue.push(std::make_pair(cmd, arg));
		
		cmd = GetNextCommand(tokenLine);
	}

	ExecuteCommandQueue();
}


void Plotter::SelectPen(int penType)
{
	for (auto pen = pens.begin(); pen != pens.end(); ++pen)
	{
		if ((*pen)->GetType() == penType)
		{
			selectedPen = (*pen);
			return;
		}
	}

	std::printf("Logic Error: No such pen\n");
	selectedPen = nullptr;
}
void Plotter::PutPenDown()
{
	if (selectedPen)
	{
		selectedPen->PutDown();
	}
	else
	{
		std::printf("Logic Error: You haven't selected a pen!\n");
	}
}
void Plotter::PutPenUp()
{
	if (selectedPen)
	{
		selectedPen->PutUp();
	}
	else
	{
		std::printf("Logic Error: You haven't selected a pen!\n");
	}
}
void Plotter::SetPenColor(int newColor)
{
	if (selectedPen)
	{
		selectedPen->SetColor(newColor);
	}
	else
	{
		std::printf("Logic Error: You haven't selected a pen!\n");
	}
}
void Plotter::DrawWithPen(DrawingDirection direction, int length)
{
	if (selectedPen)
	{
		int startX = currentPosX;
		int startY = currentPosY;

		switch (direction)
		{
		case WEST:
			currentPosX -= length;
			break;
		case EAST:
			currentPosX += length;
			break;
		case SOUTH:
			currentPosY -= length;
			break;
		case NORTH:
			currentPosY += length;
			break;
		default:
			std::printf("Synthax Error: No such direction %i\n", (int)direction);
		}

		selectedPen->DrawLine(startX, startY, currentPosX, currentPosY);
	}
	else 
	{
		std::printf("Logic Error: You haven't selected a pen!\n");
	}
}