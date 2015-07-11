#include <iostream>
#include <vector>
#include <stdlib.h>
#include <time.h>
#include <sstream>


int random(int a, int b)
{
    return b;
}

int main(int argc, char *argv[]) 
{
    srand(time(0));

    int a,b;
    std::stringstream(argv[1]) >> a;
    std::stringstream(argv[2]) >> b;
    std::cout << random(a,b) << std::endl;

    return 0;
}
