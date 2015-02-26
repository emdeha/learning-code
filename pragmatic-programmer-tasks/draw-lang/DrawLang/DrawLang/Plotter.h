#ifndef PLOTTER_H
#define PLOTTER_H


#include "Pen.h"

#include <vector>
#include <queue>
#include <functional> 
#include <memory>


enum DrawingDirection
{
	WEST,
	EAST,
	SOUTH,
	NORTH,
};

class Plotter 
{
private:
	std::queue<std::pair<char, int>> commandQueue;
	std::vector<std::pair<char, std::function<void(int)>>> executionMap;
	std::vector<std::shared_ptr<Pen>> pens;

	std::shared_ptr<Pen> selectedPen;

	int dimX;
	int dimY;

	int currentPosX;
	int currentPosY;

private:
	char GetNextCommand(std::string &tokenLine);

	void ExecuteCommandQueue();
	void CallCommand(std::pair<char, int> command);

public:
	Plotter() {}
	Plotter(int newDimX, int newDimY)
		: dimX(newDimX), dimY(newDimY) {}

	void AddPen(int penType, int penColor, char penSymbol);

	void AddCommand(char token, std::function<void(int)> executionFunction);

	void GetCommands();

public:
	void SelectPen(int penType);
	void PutPenDown();
	void PutPenUp();
	void SetPenColor(int newColor);
	void DrawWithPen(DrawingDirection, int length);
};


#endif