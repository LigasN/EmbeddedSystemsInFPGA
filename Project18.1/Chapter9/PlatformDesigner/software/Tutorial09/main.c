#include <stdio.h>

#include "system.h"
#include "sys/alt_stdio.h"
#include "sys/alt_sys_wrappers.h"
#include "sys/alt_irq.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"
#include <io.h>

#include "7SEG/7SEG.h"

/// Counter but not really ms (editing for good visual results)
volatile uint16_t msCounter = 0;
volatile const uint8_t dotDelay = 20;
volatile int8_t dotPos = -1;

/// Timer interupt handler
void timer0Interrupt( void* context )
{
	// Interrupt reset
	IOWR_ALTERA_AVALON_TIMER_STATUS( TIMER0_BASE, 0 );

	if( msCounter < 10000 )
		++msCounter;
	else
		msCounter = 0;

	if( !(msCounter % dotDelay) )
	{
		if( dotPos < 4 )
			++dotPos;
		else
			dotPos = -1;
	}

	//displayDec( msCounter, dotPos );

}

int main( )
{
	alt_putstr( "Hello from Nios II!\n" );
// Slow down our timer
	IOWR_ALTERA_AVALON_TIMER_PERIODH( TIMER0_BASE, (500000UL - 1UL) >> 16 );
	IOWR_ALTERA_AVALON_TIMER_PERIODL( TIMER0_BASE, (500000UL - 1UL) );

// Registering function to timer irq
	alt_ic_isr_register( TIMER0_IRQ_INTERRUPT_CONTROLLER_ID, TIMER0_IRQ, timer0Interrupt, NULL,
	        NULL );

// Configuring timer
	IOWR_ALTERA_AVALON_TIMER_CONTROL( TIMER0_BASE,
	        ALTERA_AVALON_TIMER_CONTROL_START_MSK | ALTERA_AVALON_TIMER_CONTROL_CONT_MSK
	                | ALTERA_AVALON_TIMER_CONTROL_ITO_MSK );

// Restart displays
	displayDec( 0, -1 );

//-------------------------------------------CHAPTER 9------------------------------------------
	IOWR_32DIRECT( PWM_BASE, 16, 1 ); // preskaller 1 -> podzia� sygna�u zegarowego na 2
	IOWR_32DIRECT( PWM_BASE, 20, 4095 ); // maksymalna warto�c PWm - rozdzielczo�c

//warto�ci poszczeg�lnych kana��w
	IOWR_32DIRECT( PWM_BASE, 0, 0 );
	IOWR_32DIRECT( PWM_BASE, 4, 2048 );
	IOWR_32DIRECT( PWM_BASE, 8, 3072 );
	IOWR_32DIRECT( PWM_BASE, 12, 4000 );
//-----------------------------------------------------------------------------------------------
//-------------------------------------------CHAPTER 10------------------------------------------
	IOWR_32DIRECT( A_7SEG_0_BASE, 16, 100 - 1 );
	IOWR_32DIRECT( A_7SEG_0_BASE, 20, 2000 - 1 );

	IOWR_32DIRECT( ENCODER_0_BASE, 4, 50000 - 1 ); //1ms elimination
	IOWR_32DIRECT( ENCODER_0_BASE, 0, 0x1000 ); // start value of counter

//-----------------------------------------------------------------------------------------------
	/* Event loop never exits. */
	while( 1 )
	{
		intDiplayHEX( IORD_32DIRECT( ENCODER_0_BASE, 0 ) );
	}

	return 0;
}
