
#include "7SEGExamples.h"

/// Example of counting function. Changes global variable digit and dot
/// to the next number or dot
void countTo9999()
{
	static uint16_t actualNumber = 0;
	static uint8_t j = 0;
	static uint8_t jLimit = 10;

	if( j > jLimit )
	{
		// Setting numbers to specific displays from decimal one
		uint16_t actualNumberCopy = actualNumber;
		for( uint8_t i = 0; i < 4; ++i )
		{
			displayData[i] =  actualNumberCopy % 10;
			actualNumberCopy /= 10;
		}

		// Prepare for the next time
		if ( actualNumber < 10000 )
			++actualNumber;
		else
			actualNumber = 0;

		// Dots preparing
		if ( dot < 4 )
			++dot;
		else
			dot = 0;

		j = 0;
	}
	else
		++j;

}
