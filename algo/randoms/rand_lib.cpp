#include "rand_lib.h"

#include <random>


int Random(int beg, int end) 
{
    std::random_device rd;
    std::mt19937 gen(rd());

    std::uniform_int_distribution<int> d(beg, end);

    return d(gen);
}
