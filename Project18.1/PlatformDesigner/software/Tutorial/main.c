
#include "system.h"
#include "sys/alt_stdio.h"
#include "sys/alt_sys_wrappers.h"
#include "altera_avalon_pio_regs.h"
#include "7SEG/7SEG.h"

#define FALSE 0
#define TRUE 1

int main()
{ 
  alt_putstr("Hello from Nios II to you people!\n");

  unsigned int j = 0;
  unsigned int jLimit = 10;
  unsigned int k = 0;
  unsigned int dot = 0;
  uint8_t willDot = FALSE;
  unsigned int digit[4] = {};
  unsigned int diode = 0;
  unsigned int sw = 0;

  /* Event loop never exits. */
  while (1)
  {
	  sw = 0;
	  digit[0] = k / 1000;
	  digit[1] = k % 1000 / 100;
	  digit[2] = k % 100 / 10;
	  digit[3] = k % 10;
	  for ( int i = 1; i <= DS4; ++i )
	  {
		  willDot =( dot == i ? TRUE : FALSE );
		  setDigit( digit[i - 1], i, willDot );
		  ALT_USLEEP( 1000 );
	  }
	  if( j > jLimit )
	  {
		  ++k;
		  ++dot;
		  j = 0;
		  ++diode;
		  diode = diode % 16;
	  }
	  if( k > 9999 )
	  {
		  k = 0;
	  }
	  if( dot > 4 )
	  {
		  dot = 1;
	  }
	  ++j;

	  sw = IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);

	  if(sw !=0)
	  {
		  if(!(sw & (1<<0)))
		  {
			  k = 0;
		  }
		  else if(!(sw & (1<<1)))
		  {
			  ++jLimit;
		  }
		  else if(!(sw & (1<<2)))
		  {
			  --jLimit;
		  }

		  ALT_USLEEP( 100 );
	  }

	  IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, ~diode);
  }

  return 0;
}
