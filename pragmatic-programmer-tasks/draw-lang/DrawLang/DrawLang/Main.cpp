#include <iostream>
#include <string>
#include <vector>
#include <queue>
#include <functional>

#include "Plotter.h"
#include "Utils.h"


Plotter mainPlotter;


void InitPens()
{
	mainPlotter.AddPen(0, 1, '=');
	mainPlotter.AddPen(1, 1, '+');
	mainPlotter.AddPen(2, 1, '-');
	mainPlotter.AddPen(3, 1, '>');
	mainPlotter.AddPen(4, 1, '<');
}

void InitCommands()
{
	mainPlotter.AddCommand('p', 
		[](int param) 
	{
		// select 'param' pen 
		std::printf("Selecting pen No: %i\n", param);
		mainPlotter.SelectPen(param);
	});

	mainPlotter.AddCommand('d',
		[](int param)
	{
		// put pen down
		std::printf("Putting pen down\n");
		mainPlotter.PutPenDown();
	});

	mainPlotter.AddCommand('u',
		[](int param)
	{
		// get pen up
		std::printf("Getting pen up\n");
		mainPlotter.PutPenUp();
	});

	mainPlotter.AddCommand('w',
		[](int param)
	{
		// draw west by 'param' cm
		std::printf("Drawing west by %i cm\n", param);
		mainPlotter.DrawWithPen(WEST, param);
	});

	mainPlotter.AddCommand('n',
		[](int param)
	{
		// draw north by 'param' cm
		std::printf("Drawing north by %i cm\n", param);
		mainPlotter.DrawWithPen(NORTH, param);
	});

	mainPlotter.AddCommand('e', 
		[](int param)
	{
		// draw east by 'param' cm
		std::printf("Drawing east by %i cm\n", param);
		mainPlotter.DrawWithPen(EAST, param);
	});

	mainPlotter.AddCommand('s',
		[](int param)
	{
		// draw south by 'param' cm
		std::printf("Drawing south by %i cm\n", param);
		mainPlotter.DrawWithPen(SOUTH, param);
	});

	mainPlotter.AddCommand('c',
		[](int param)
	{
		// sets the pen's color
		std::printf("Changed color with %i\n", param);
		mainPlotter.SetPenColor(param);
	});
}

int main()
{
	InitPens();
	InitCommands();

	mainPlotter.GetCommands();	

	return 0;
}