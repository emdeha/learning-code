#include <iostream>
#include <vector>
#include <sstream>
#include <random>
#include <iomanip>
#include <map>
#include <cmath>
#include <cassert>
#include <cstring>


const char *BIG_SAMPLE_OPT = "-big";

int RandomZeroOne()
{
    std::random_device rd;
    std::mt19937 gen(rd());

    std::bernoulli_distribution d(0.5);

    return d(gen);
}

int RandomRange(int a, int b)
{
    assert(b > a);
    size_t iterations = std::ceil(std::log2(b));
    assert(iterations < sizeof(int) * 8);

    int number = 0;
    for (size_t i = 0; i < iterations; ++i)
    {
        int bit = RandomZeroOne() << i;

        number = number | bit;
    }

    if (a <= number && number <= b)
        return number;
    else
        return RandomRange(a, b);
}

int main(int argc, char *argv[]) 
{
    int a,b;
    bool isBigSample = false;
    if (strncmp(argv[1], BIG_SAMPLE_OPT, strlen(BIG_SAMPLE_OPT)) == 0)
    {
        isBigSample = true;
        std::stringstream(argv[2]) >> a;
        std::stringstream(argv[3]) >> b;
    }
    else
    {
        std::stringstream(argv[1]) >> a;
        std::stringstream(argv[2]) >> b;
    }

    if (isBigSample)
    {
        std::map<int, int> hist;
        for (int i = 0; i < 100000; ++i) 
        {
            ++hist[RandomRange(a, b)];
        }
        for (auto p : hist)
        {
            std::cout << std::setw(5) << p.first
                      << ' ' << std::string(p.second/500, '*') << '\n';
        }
    }
    else
    {
        std::cout << RandomRange(a, b) << '\n';
    }

    return 0;
}
