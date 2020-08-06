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

/// Refreshes displays and sets correct data on the current one
void refreshDisplay( void )
{
	static uint8_t display = 0;
	// Setting displays off
	IOWR_ALTERA_AVALON_PIO_DATA( SEG_SWITCH_BASE, 0 );
	if ( displayData[display] <= PAUSE )
	{
		// Setting digit
		IOWR_ALTERA_AVALON_PIO_DATA(
				SEG_SEG_BASE, digitDecoder[displayData[display]] | (dot == display ?(1<<SEG_DP):0));
		// Setting display
		IOWR_ALTERA_AVALON_PIO_DATA(SEG_SWITCH_BASE, (1<<(display)));
	}
	// Maybe dot is turned on for this display
	else if( dot == display )
	{
		// Setting digit
		IOWR_ALTERA_AVALON_PIO_DATA( SEG_SEG_BASE, (1<<SEG_DP) );
		// Setting display
		IOWR_ALTERA_AVALON_PIO_DATA(SEG_SWITCH_BASE, (1<<(display)));
	}
	// Changing display to next one with check if display number isn't greater than it's amount
	if (display < 3)
		++display;
	else
		display = 0;
}

/// Set displays to display decimal number from 0 up to 9999.
void displayDec( uint16_t decNumber )
{
	// Setting numbers to specific displays from decimal one
	for( uint8_t i = 0; i < 4; ++i )
	{
		displayData[i] =  decNumber % 10;
		decNumber /= 10;
	}

	// Dot is not allowed here
	dot = 0;

	// Ready to refresh displays
	refreshDisplay();
}


