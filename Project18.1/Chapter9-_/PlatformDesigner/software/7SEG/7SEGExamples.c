#include "7SEGExamples.h"

/// Example of counting function. Changes global variable digit and dot
/// to the next number or dot
void countTo9999( )
{
	static uint16_t actualNumber = 0;
	static uint8_t j = 0;
	static uint8_t dot = 0;
	static uint8_t jLimit = 10;

	if( j > jLimit )
	{
		displayDec( actualNumber, dot++ );

		// Prepare for the next time
		if( actualNumber < 10000 )
			++actualNumber;
		else
			actualNumber = 0;

		// Dots preparing
		if( dot > 3 )
			dot = 0;

		j = 0;
	}
	else
		++j;

}
