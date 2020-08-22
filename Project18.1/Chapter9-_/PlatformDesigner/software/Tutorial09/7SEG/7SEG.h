#ifndef _7SEG_H_
#define _7SEG_H_

#include <stdint.h>

#define SEG_DP 7
#define SEG_A 0
#define SEG_B 1
#define SEG_C 2
#define SEG_D 3
#define SEG_E 4
#define SEG_F 5
#define SEG_G 6

#define PAUSE 16

#define FALSE 0
#define TRUE 1

void setDigit( uint8_t digit, uint8_t dp, uint8_t pos );
void displayDec( uint16_t decNumber, int8_t dotpos );
void intDiplayHEX( uint16_t number );

#endif //_7SEG_H_
