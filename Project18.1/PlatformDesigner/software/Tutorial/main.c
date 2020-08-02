#include "system.h"
#include "sys/alt_stdio.h"
#include "sys/alt_sys_wrappers.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"

#include "7SEG/7SEG.h"
#include "7SEG/7SEGExamples.h"

/// Timer interupt handler
void timer0Interrupt( void* context )
{
	IOWR_ALTERA_AVALON_TIMER_STATUS( TIMER0_BASE, 0 );
	refreshDisplay( );
	// countTo9999( );
}

void SWInterrupt( void* context )
{
	static uint16_t counter = 0;

	IOWR_ALTERA_AVALON_PIO_EDGE_CAP( SW_BASE, 0 );

	++counter;
	displayDec( counter );

}

int main( )
{
	alt_putstr( "Hello from Nios II to you people!\n" );

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

	}

	return 0;
}
