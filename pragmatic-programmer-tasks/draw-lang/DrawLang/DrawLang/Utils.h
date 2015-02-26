#ifndef UTILS_H
#define UTILS_H


#include <string>


extern std::string Trim(const std::string &str, const std::string &whiteSpace = " \t");
extern std::string Reduce(const std::string &str, const std::string &fill = " ", 
					      const std::string &whiteSpace = " \t");


#endif