#include <iostream>
#include <functional>
#include <string>


#define StrictWeakOrdering typename

template <typename T, StrictWeakOrdering Cmp>
T& min(T& a, T& b, Cmp cmp)
{
    if (cmp(b, a)) return b;
    return a;
}

template <typename T, StrictWeakOrdering Cmp>
T& max(T& a, T& b, Cmp cmp)
{
    if (cmp(a, b)) return a;
    return b;
}

template <typename T, StrictWeakOrdering Cmp>
std::pair<T&, T&> sort(T& a, T& b, Cmp cmp)
{
    return { min(a, b, cmp), max(a, b, cmp) };
}

class Person
{
public:
    int salary;
    int position;

    Person(int _salary, int _position)
        : salary(_salary), position(_position)
    {
    }

    std::string ToString()
    {
        return std::to_string(salary) + " " + std::to_string(position);
    }
};


int main()
{
    Person a = { 1000, 1 };
    Person b = { 2000, 1 };

    auto sorted = sort(a, b, [](const Person &p1, const Person &p2)
                             {
                                 return p1.position < p2.position;
                             });

    std::cout << "Min (" << a.ToString() << ", " << b.ToString() << "): "
              << "(" 
              << sorted.first.ToString() << ", " 
              << sorted.second.ToString() 
              << ")" << std::endl;

    std::cout << "Address a: " << &a << " =? " << &sorted.first << "\n"
              << "Address b: " << &b << " =? " << &sorted.second << "\n";

    return 0;
}
