#include <iostream>
#include <algorithm>
#include <vector>

#include "rand_lib.h"


void PrintVector(std::vector<int> &vect)
{
    for (size_t i = 0; i < vect.size(); ++i)
    {
        std::cout << vect[i] << " ";
    }
    std::cout << std::endl;
} 

void PermuteBySorting(std::vector<int> &a)
{
    size_t n = a.size();
    size_t nCube = n*n*n;
    std::vector<int> p(n);

    for (size_t i = 0; i < n; ++i)
    {
        p[i] = Random(0, nCube);
    }
    std::cout << "Ranks:\n";
    PrintVector(p);

    std::vector<int> toRank = a;
    for (size_t i = 0; i < n; ++i)
    {
        auto minIt = std::min_element(std::begin(p), std::end(p));
        int minId = std::distance(std::begin(p), minIt);
        p[minId] = 99999;

        auto maxIt = std::max_element(std::begin(toRank), std::end(toRank));
        int maxId = std::distance(std::begin(toRank), maxIt);
        toRank[maxId] = -1;

        std::swap(a[maxId], a[minId]);
    }
}

int main()
{
    std::vector<int> a = { 1,2,3,4,5 };

    PermuteBySorting(a);

    for (size_t i = 0; i < a.size(); ++i)
    {
        std::cout << a[i] << " ";
    }
    std::cout << std::endl;

    return 0;
}
