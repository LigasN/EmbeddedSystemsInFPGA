#include <stdint.h>
#include <io.h>

#include "system.h"
#include "sys/alt_stdio.h"
#include "sys/alt_sys_wrappers.h"
#include "sys/alt_irq.h"

#define WS2812_STATUS_REG	24
#define WS2812_STATUS_INT	(1<<0)

#define WS2812_CONFIG_REG	20
#define WS2812_CONFIG_INT	(1<<1)
#define WS2812_CONFIG_START	(1<<0)

#define WS2812_T0H_REG		0
#define WS2812_T0L_REG		4
#define WS2812_T1H_REG		8
#define WS2812_T1L_REG		12
#define WS2812_RES_REG		16

volatile uint8_t WS2812Done = 0;
void WS2812Interrupt( void* context )
{
	//kasowanie flagi przerwania
	IOWR_32DIRECT( WS2812_RAM_INT_0_BASE, WS2812_STATUS_REG, 0 );
	WS2812Done = 1;
}

void WS2812UpdateWaitInt( void )
{
	IOWR_32DIRECT( WS2812_RAM_INT_0_BASE, WS2812_CONFIG_REG,
	WS2812_CONFIG_INT | WS2812_CONFIG_START );
	while( WS2812Done != 1 )
		;
	WS2812Done = 0;
	ALT_USLEEP( 5000 );
}

int main( )
{
	alt_putstr( "Hello from Nios II!\n" );

	// ustawiamy czasy konieczne do wygenerowania prawidłowych przebiegów sterujących
	IOWR_32DIRECT( WS2812_RAM_INT_0_BASE, WS2812_T0H_REG, NIOS2_CPU_FREQ * 350LL / 1000000000LL );
	IOWR_32DIRECT( WS2812_RAM_INT_0_BASE, WS2812_T0L_REG, NIOS2_CPU_FREQ * 900LL / 1000000000LL );
	IOWR_32DIRECT( WS2812_RAM_INT_0_BASE, WS2812_T1H_REG, NIOS2_CPU_FREQ * 900LL / 1000000000LL );
	IOWR_32DIRECT( WS2812_RAM_INT_0_BASE, WS2812_T1L_REG, NIOS2_CPU_FREQ * 350LL / 1000000000LL );
	IOWR_32DIRECT( WS2812_RAM_INT_0_BASE, WS2812_RES_REG,
	        NIOS2_CPU_FREQ * 100000LL / 1000000000LL );

	alt_ic_isr_register( WS2812_RAM_INT_0_IRQ_INTERRUPT_CONTROLLER_ID, WS2812_RAM_INT_0_IRQ,
	        WS2812Interrupt, NULL, NULL );

	IOWR_32DIRECT( RAM_WS2812_BASE, 0, 0x00FF00 );
	IOWR_32DIRECT( RAM_WS2812_BASE, 4, 0x0000FF );

	WS2812UpdateWaitInt( );

	uint32_t temp;
	while( 1 )
	{

		for( int j = 0; j < 255; ++j )
		{
			temp = IORD_32DIRECT( RAM_WS2812_BASE, 0 );
			temp += 0x000001;
			temp -= 0x000100;
			IOWR_32DIRECT( RAM_WS2812_BASE, 0, temp );

			temp = IORD_32DIRECT( RAM_WS2812_BASE, 4 );
			temp += 0x000100;
			temp -= 0x000001;
			IOWR_32DIRECT( RAM_WS2812_BASE, 4, temp );

			WS2812UpdateWaitInt( );

		}

		for( int j = 0; j < 255; ++j )
		{
			temp = IORD_32DIRECT( RAM_WS2812_BASE, 0 );
			temp += 0x010000;
			temp -= 0x000001;
			IOWR_32DIRECT( RAM_WS2812_BASE, 0, temp );

			temp = IORD_32DIRECT( RAM_WS2812_BASE, 4 );
			temp += 0x010000;
			temp -= 0x000100;
			IOWR_32DIRECT( RAM_WS2812_BASE, 4, temp );
			WS2812UpdateWaitInt( );

		}
		for( int j = 0; j < 255; ++j )
		{
			temp = IORD_32DIRECT( RAM_WS2812_BASE, 0 );
			temp += 0x000100;
			temp -= 0x010000;
			IOWR_32DIRECT( RAM_WS2812_BASE, 0, temp );

			temp = IORD_32DIRECT( RAM_WS2812_BASE, 4 );
			temp += 0x000001;
			temp -= 0x010000;
			IOWR_32DIRECT( RAM_WS2812_BASE, 4, temp );
			WS2812UpdateWaitInt( );

		}
	}

	return 0;
}

