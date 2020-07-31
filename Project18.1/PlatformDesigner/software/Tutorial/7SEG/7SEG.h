
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

#define DS1 1
#define DS2 2
#define DS3 3
#define DS4 4
#define DS_OFF 0

void setDigit(uint8_t digit, uint8_t display, uint8_t dot);

#endif //_7SEG_H_
