
#include "system.h"
#include "sys/alt_stdio.h"
#include "sys/alt_sys_wrappers.h"
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_timer.h"

#include "7SEG/7SEG.h"

/// Example of counting function. Changes global variable digit and dot
/// to the next number or dot
void refreshNumbers()
{
	static uint16_t actualNumber = 0;
	static uint8_t j = 0;
	static uint8_t jLimit = 10;

	if( j > jLimit )
	{
		// Obviously I could update only one number. This function is
		// called 3 times too much. But then I would need one more static variable
		// or make displayNumber global. I decided to be in refreshDisplay() more close
		// to the example from book.
		uint16_t actualNumberCopy = actualNumber;
		for( uint8_t i = 0; i < 4; ++i )
		{
			displayData[i] =  actualNumberCopy % 10;
			actualNumberCopy /= 10;
		}

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

/// Timer interupt handler
void timer0Interrupt(void* context)
{
		IOWR_ALTERA_AVALON_TIMER_STATUS( TIMER0_BASE, 0 );
		refreshDisplay();
		refreshNumbers();
}

int main()
{ 
  alt_putstr("Hello from Nios II to you people!\n");

  // Registering function to timer irq
  alt_ic_isr_register(
		  TIMER0_IRQ_INTERRUPT_CONTROLLER_ID, TIMER0_IRQ, timer0Interrupt, NULL, NULL);

  // Configuring timer
  IOWR_ALTERA_AVALON_TIMER_CONTROL( TIMER0_BASE,
								  	ALTERA_AVALON_TIMER_CONTROL_START_MSK |
									ALTERA_AVALON_TIMER_CONTROL_CONT_MSK |
									ALTERA_AVALON_TIMER_CONTROL_ITO_MSK );

  /* Event loop never exits. */
  while (1)
  {

  }

  return 0;
}
