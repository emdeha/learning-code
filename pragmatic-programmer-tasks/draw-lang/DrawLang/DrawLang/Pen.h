#ifndef PEN_H
#define PEN_H


class Pen
{
private:
	int type;
	int color;
	char symbol;

	bool isDown;

public:
	Pen() {}
	Pen(int newType, int newColor, char newSymbol)
		: type(newType), color(newColor), symbol(newSymbol), isDown(false) {}

	int GetType()
	{
		return type;
	}

	void PutDown()
	{
		isDown = true;
	}
	void PutUp()
	{
		isDown = false;
	}

	void SetColor(int newColor)
	{
		color = newColor;
	}

	void DrawLine(int startX, int startY, int endX, int endY);
};


#endif