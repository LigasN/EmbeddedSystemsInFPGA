#include "system.h"
#include "sys/alt_stdio.h"
#include "sys/alt_sys_wrappers.h"
#include <io.h>

#include "7SEG.h"

const uint8_t digitDecoder[17] =
	{ (1 << SEG_A) | (1 << SEG_B) | (1 << SEG_C) | (1 << SEG_D) | (1 << SEG_E) | (1 << SEG_F), // 0
	  (1 << SEG_B) | (1 << SEG_C), // 1
	  (1 << SEG_A) | (1 << SEG_B) | (1 << SEG_D) | (1 << SEG_E) | (1 << SEG_G), // 2
	  (1 << SEG_A) | (1 << SEG_B) | (1 << SEG_C) | (1 << SEG_D) | (1 << SEG_G), // 3
	  (1 << SEG_B) | (1 << SEG_C) | (1 << SEG_F) | (1 << SEG_G), // 4
	  (1 << SEG_A) | (1 << SEG_C) | (1 << SEG_D) | (1 << SEG_F) | (1 << SEG_G), // 5
	  (1 << SEG_A) | (1 << SEG_C) | (1 << SEG_D) | (1 << SEG_E) | (1 << SEG_F) | (1 << SEG_G), // 6
	  (1 << SEG_A) | (1 << SEG_B) | (1 << SEG_C), // 7
	  (1 << SEG_A) | (1 << SEG_B) | (1 << SEG_C) | (1 << SEG_D) | (1 << SEG_E) | (1 << SEG_F)
	          | (1 << SEG_G), // 8
	  (1 << SEG_A) | (1 << SEG_B) | (1 << SEG_C) | (1 << SEG_D) | (1 << SEG_F) | (1 << SEG_G), // 9
	  (1 << SEG_A) | (1 << SEG_B) | (1 << SEG_C) | (1 << SEG_E) | (1 << SEG_F) | (1 << SEG_G), //A
	  (1 << SEG_C) | (1 << SEG_D) | (1 << SEG_E) | (1 << SEG_F) | (1 << SEG_G), //B
	  (1 << SEG_A) | (1 << SEG_D) | (1 << SEG_E) | (1 << SEG_F), //C
	  (1 << SEG_B) | (1 << SEG_C) | (1 << SEG_D) | (1 << SEG_E) | (1 << SEG_G), //D
	  (1 << SEG_A) | (1 << SEG_D) | (1 << SEG_E) | (1 << SEG_F) | (1 << SEG_G), //E
	  (1 << SEG_A) | (1 << SEG_E) | (1 << SEG_F) | (1 << SEG_G), //F
	  (1 << SEG_G) // -
	    };

void setDigit( uint8_t digit, uint8_t dp, uint8_t pos )
{
	if( pos < 4 )
	{
		if( digit > 16 )
		{
			IOWR_32DIRECT( A_7SEG_0_BASE, pos * 4, 0 | (dp != 0 ? (1 << SEG_DP) : 0) );
		}
		else
		{
			IOWR_32DIRECT( A_7SEG_0_BASE, pos * 4,
			        digitDecoder[digit] | (dp != 0 ? (1 << SEG_DP) : 0) );
		}
	}
}

/// Set displays to display decimal number from 0 up to 9999.
void displayDec( uint16_t decNumber, int8_t dotpos )
{
	// Setting numbers to specific displays from decimal one
	for( uint8_t i = 0; i < 4; ++i )
	{
		setDigit( decNumber % 10, dotpos == i ? TRUE : FALSE, i );
		decNumber /= 10;
	}

}
