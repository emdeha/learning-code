#include <iostream>
#include <random>
#include <vector>

#include "rand_lib.h"


int main() 
{
    std::vector<int> arr = { 1,5,2,3,0,9,3,84,9,3,9,2,3,1 };
    std::vector<int> b(arr.size());
    int n = arr.size();
    int offset = Random(1, n);

    for (int i = 0; i < n; ++i) 
    {
        int dest = i + offset;
        if (dest >= n)
        {
            dest -= n;
        }
        b[dest] = arr[i];
    }

    for (int i = 0; i < n; ++i)
    {
        std::cout << b[i] << " ";
    }
    std::cout << std::endl;

    return 0;
}
