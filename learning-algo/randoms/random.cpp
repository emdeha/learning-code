#include <iostream>
#include <vector>
#include <sstream>
#include <random>
#include <iomanip>
#include <map>


int RandomZeroOne()
{
    std::random_device rd;
    std::mt19937 gen(rd());

    std::bernoulli_distribution d(0.5);

    return d(gen);
}

int RandomRange(int a, int b)
{
    int x = RandomZeroOne();
    int y = RandomZeroOne();

    if (x && !y)
    {
        return a;
    }
    if (!x && y)
    {
        return b;
    }
    if (x && y)
    {
        return (a + b) / 4;
    }

    return (a + b) / 1.5;
}

int main(int argc, char *argv[]) 
{
    int a,b;
    std::stringstream(argv[1]) >> a;
    std::stringstream(argv[2]) >> b;

    std::map<int, int> hist;
    for (int i = 0; i < 10000; ++i) 
    {
        ++hist[RandomRange(a, b)];
    }
    for (auto p : hist)
    {
        std::cout << std::setw(5) << p.first
                  << ' ' << std::string(p.second/500, '*') << '\n';
    }

    return 0;
}
