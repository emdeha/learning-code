#include "Utils.h"


std::string Trim(const std::string &str, const std::string &whiteSpace)
{
	const auto strBegin = str.find_first_not_of(whiteSpace);
	if (strBegin == std::string::npos)
		return "";

	const auto strEnd = str.find_last_not_of(whiteSpace);
	const auto strRange = strEnd - strBegin + 1;

	return str.substr(strBegin, strRange);
}

std::string Reduce(const std::string &str, const std::string &fill, const std::string &whiteSpace)
{
	auto result = Trim(str, whiteSpace);
	
	auto beginSpace = result.find_first_of(whiteSpace);
	while (beginSpace != std::string::npos)
	{
		const auto endSpace = result.find_first_not_of(whiteSpace, beginSpace);
		const auto range = endSpace - beginSpace;

		result.replace(beginSpace, range, fill);

		const auto newStart = beginSpace + fill.length();
		beginSpace = result.find_first_of(whiteSpace, newStart);
	}

	return result;
}