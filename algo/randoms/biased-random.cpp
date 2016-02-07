#include <iostream>
#include <random>
#include <map>
#include <string>
#include <iomanip>
#include <sstream>


bool BiasedRandom(double p)
{
    std::random_device rd;
    std::mt19937 gen(rd());

    std::bernoulli_distribution d(p);

    return d(gen);
}

bool RandomZeroOne(double p)
{
    bool x, y;

    do 
    {
        x = BiasedRandom(p);
        y = BiasedRandom(p);
    }
    while (x == y);

    return x;
}

int main(int argc, char **argv) 
{
    double p;
    std::stringstream(argv[1]) >> p;

    std::map<bool, int> hist;
    for (int i = 0; i < 10000; ++i) 
    {
        ++hist[RandomZeroOne(p)];
    }
    for (auto p : hist)
    {
        std::cout << std::boolalpha << std::setw(5) << p.first
                  << ' ' << std::string(p.second/500, '*') << '\n';
    }

    return 0;
}
