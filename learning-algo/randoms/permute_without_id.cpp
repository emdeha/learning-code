#include <iostream>
#include <vector>

#include "rand_lib.h"


int main()
{
    std::vector<int> arr = { 8,2,5,1,4,9,3,10,6,7 };
    int n = arr.size();
    
    for (int i = 0; i < n-1; ++i)
    {
        std::swap(arr[i], arr[Random(i+1, n-1)]);
    }

    for (int i = 0; i < n; ++i)
    {
        std::cout << arr[i] << " ";
    }
    std::cout << std::endl;

    return 0;
}
