
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

/// Digits to display on 7SEG displays
/// Lower index == display more to the left side of board
volatile uint8_t displayData[4];

/// Dots to display on 7SEG displays
volatile uint8_t dot;

void refreshDisplay();

#endif //_7SEG_H_
