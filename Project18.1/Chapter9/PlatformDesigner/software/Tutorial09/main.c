#include "system.h"
#include "sys/alt_stdio.h"
#include <io.h>

int main( )
{
	alt_putstr( "Hello from Nios II!\n" );

	IOWR_32DIRECT( PWM4_0_BASE, 16, 1 ); // preskaller 1 -> podzia� sygna�u zegarowego na 2
	IOWR_32DIRECT( PWM4_0_BASE, 20, 4095 ); // maksymalna warto�c PWm - rozdzielczo�c

	//warto�ci poszczeg�lnych kana��w
	IOWR_32DIRECT( PWM4_0_BASE, 0, 0 );
	IOWR_32DIRECT( PWM4_0_BASE, 4, 2048 );
	IOWR_32DIRECT( PWM4_0_BASE, 8, 3072 );
	IOWR_32DIRECT( PWM4_0_BASE, 12, 4000 );

	/* Event loop never exits. */
	while( 1 )
		;

	return 0;
}
