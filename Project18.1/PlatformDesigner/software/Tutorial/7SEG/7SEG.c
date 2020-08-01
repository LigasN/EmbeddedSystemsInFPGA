#include "system.h"
#include "sys/alt_stdio.h"
#include "sys/alt_sys_wrappers.h"
#include "altera_avalon_pio_regs.h"

#include "7SEG.h"


const uint8_t digitDecoder[17] =
						   {
							(1<<SEG_A)|(1<<SEG_B)|(1<<SEG_C)|(1<<SEG_D)|(1<<SEG_E)|(1<<SEG_F), // 0
							(1<<SEG_B)|(1<<SEG_C), // 1
							(1<<SEG_A)|(1<<SEG_B)|(1<<SEG_D)|(1<<SEG_E)|(1<<SEG_G), // 2
							(1<<SEG_A)|(1<<SEG_B)|(1<<SEG_C)|(1<<SEG_D)|(1<<SEG_G), // 3
							(1<<SEG_B)|(1<<SEG_C)|(1<<SEG_F)|(1<<SEG_G), // 4
							(1<<SEG_A)|(1<<SEG_C)|(1<<SEG_D)|(1<<SEG_F)|(1<<SEG_G), // 5
							(1<<SEG_A)|(1<<SEG_C)|(1<<SEG_D)|(1<<SEG_E)|(1<<SEG_F)|(1<<SEG_G), // 6
							(1<<SEG_A)|(1<<SEG_B)|(1<<SEG_C), // 7
							(1<<SEG_A)|(1<<SEG_B)|(1<<SEG_C)|(1<<SEG_D)|(1<<SEG_E)|(1<<SEG_F)|(1<<SEG_G), // 8
							(1<<SEG_A)|(1<<SEG_B)|(1<<SEG_C)|(1<<SEG_D)|(1<<SEG_F)|(1<<SEG_G), // 9
							(1<<SEG_A)|(1<<SEG_B)|(1<<SEG_C)|(1<<SEG_E)|(1<<SEG_F)|(1<<SEG_G),//A
							(1<<SEG_C)|(1<<SEG_D)|(1<<SEG_E)|(1<<SEG_F)|(1<<SEG_G),//B
							(1<<SEG_A)|(1<<SEG_D)|(1<<SEG_E)|(1<<SEG_F),//C
							(1<<SEG_B)|(1<<SEG_C)|(1<<SEG_D)|(1<<SEG_E)|(1<<SEG_G),//D
							(1<<SEG_A)|(1<<SEG_D)|(1<<SEG_E)|(1<<SEG_F)|(1<<SEG_G),//E
							(1<<SEG_A)|(1<<SEG_E)|(1<<SEG_F)|(1<<SEG_G),//F
							(1<<SEG_G) // -
						   };


/// Digits to display on 7SEG displays
/// Lower index == display more to the left side of board
uint8_t digit[4] = { 0, 0, 0, 0};

/// Dots to display on 7SEG displays
uint8_t dot = 0;

void refreshDisplay( void )
{
	static uint8_t display = 0;
	// Setting displays off
	IOWR_ALTERA_AVALON_PIO_DATA( SEG_SWITCH_BASE, 0 );
	if ( digit[display] <= PAUSE)
	{
		// Setting digit
		IOWR_ALTERA_AVALON_PIO_DATA(
				SEG_SEG_BASE, digitDecoder[digit[display]] | (dot == display ?(1<<SEG_DP):0));
		// Setting display
		IOWR_ALTERA_AVALON_PIO_DATA(SEG_SWITCH_BASE, (1<<(display)));
	}
	// Changing display to next one with check if display number isn't greater than it's amount
	if (display < 3)
		++display;
	else
		display = 0;
}

/// Example of counting funtion. Changes global variable digit and dot
/// to the next number or dot
void refreshNumbers()
{
	static unsigned int actualNumber = 0;
	static unsigned int j = 0;
	static unsigned int jLimit = 10;

	if( j > jLimit )
	{
		// Obviously I could update only one number. This function is
		// called 3 times too much. But then I would need one more static variable
		// or make displayNumber global. I decided to be in refreshDisplay() more close
		// to the example from book.
		digit[0] = actualNumber / 1000;
		digit[1] = actualNumber % 1000 / 100;
		digit[2] = actualNumber % 100 / 10;
		digit[3] = actualNumber % 10;

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
