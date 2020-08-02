#include <stdio.h>

#include "system.h"
#include "sys/alt_stdio.h"
#include "sys/alt_sys_wrappers.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"

#include "7SEG/7SEG.h"
#include "7SEG/7SEGExamples.h"

/// Counter of pushing buttons
volatile uint16_t msCounter = 0;

/// Timer interupt handler
void timer0Interrupt( void* context )
{
	// Interrupt reset
	IOWR_ALTERA_AVALON_TIMER_STATUS( TIMER0_BASE, 0 );
	refreshDisplay( );

	++msCounter;
}

/// Switch interupt handler
void SWInterrupt( void* context )
{
// Interrupt reset
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP( SW_BASE, 0 );

	//++counter;
	//displayDec( counter );

}

int main( )
{
	alt_putstr( "Hello from Nios II to you people!\n" );

	// Slow down our timer
	IOWR_ALTERA_AVALON_TIMER_PERIODH( TIMER0_BASE, (50000UL - 1UL) >> 16 );
	IOWR_ALTERA_AVALON_TIMER_PERIODL( TIMER0_BASE, (50000UL - 1UL) );

	// Registering function to timer irq
	alt_ic_isr_register( TIMER0_IRQ_INTERRUPT_CONTROLLER_ID, TIMER0_IRQ, timer0Interrupt, NULL,
	        NULL );

	// Configuring timer
	IOWR_ALTERA_AVALON_TIMER_CONTROL( TIMER0_BASE,
	        ALTERA_AVALON_TIMER_CONTROL_START_MSK | ALTERA_AVALON_TIMER_CONTROL_CONT_MSK
	                | ALTERA_AVALON_TIMER_CONTROL_ITO_MSK );

	// Registering function to switch irq
	alt_ic_isr_register( SW_IRQ_INTERRUPT_CONTROLLER_ID, SW_IRQ, SWInterrupt, NULL, NULL );

	// Setting ports ( of switches ) which should generate interrupt
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK( SW_BASE, 0b111 );

	// Restart displays
	displayDec( 0 );

	/* Event loop never exits. */
	while( 1 )
	{
		if( !(IORD_ALTERA_AVALON_PIO_DATA( SW_BASE ) & (1 << 0)) )
		{
			alt_irq_context context = alt_irq_disable_all( );
			IOWR_ALTERA_AVALON_TIMER_SNAPH( TIMER0_BASE, 0 );
			uint16_t copyMs = msCounter;

			uint8_t valid = !(IORD_ALTERA_AVALON_TIMER_STATUS( TIMER0_BASE )
			        & ALTERA_AVALON_TIMER_STATUS_TO_MSK);

			alt_irq_enable_all( context );

			uint32_t timerValue = IORD_ALTERA_AVALON_TIMER_SNAPH( TIMER0_BASE );
			timerValue <<= 16;
			timerValue |= IORD_ALTERA_AVALON_TIMER_SNAPL( TIMER0_BASE );

			printf( "T = %u.%03lu ms %c \r\n", copyMs, 999 - timerValue / 50, valid ? ' ' : '*' );
			displayDec( copyMs );
			while( !(IORD_ALTERA_AVALON_PIO_DATA( SW_BASE ) & (1 << 0)) )
				;
		}
	}

	return 0;
}
