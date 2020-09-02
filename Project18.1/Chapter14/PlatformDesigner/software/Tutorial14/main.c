#include <io.h>
#include <stdint.h>

#include "system.h"
#include "sys/alt_stdio.h"
#include "sys/alt_sys_wrappers.h"

void HDMIClear( uint32_t base )
{
	for( int i = 0; i <= 6360; i++ )
	{
		IOWR_8DIRECT( base, i, ' ' );
	}
}

void HDMIPutCharX( uint32_t base, uint32_t position, char c )
{
	if( position > 6360 )
		return;
	IOWR_8DIRECT( base, position, c );
}

void HDMIPutString( uint32_t base, uint8_t col, uint8_t row, char* s )
{
	uint32_t position = row * 106 + col;
	do
	{
		HDMIPutCharX( base, position, *s );
		position++;
	} while( *(s++) != 0 );
}

int main( )
{
	alt_putstr( "Hello from Nios II!\n" );

	HDMIClear (DISPLAYHDMITEXT_0_BASE);

	HDMIPutString( DISPLAYHDMITEXT_0_BASE, 71, 5, "                             .-." );
	HDMIPutString( DISPLAYHDMITEXT_0_BASE, 71, 6, "(___________________________()6 `-," );
	HDMIPutString( DISPLAYHDMITEXT_0_BASE, 71, 7, "(   ______________________   /''\"`" );
	HDMIPutString( DISPLAYHDMITEXT_0_BASE, 71, 8, "//\\\\                      //\\\\" );
	HDMIPutString( DISPLAYHDMITEXT_0_BASE, 71, 9, "\"\" \"\"                     \"\" \"\"" );
	HDMIPutString( DISPLAYHDMITEXT_0_BASE, 71, 10, "jgs" );
	while( 1 )
	{
		for( int i = 0; i < 60; i++ )
		{
			HDMIPutString( DISPLAYHDMITEXT_0_BASE, 0, i, "Obraz HDMI prosto z Intel FPGA MAX10!" );
			ALT_USLEEP( 500000 );
			HDMIPutString( DISPLAYHDMITEXT_0_BASE, 0, i, "                                     " );
		}
	}

	return 0;
}
