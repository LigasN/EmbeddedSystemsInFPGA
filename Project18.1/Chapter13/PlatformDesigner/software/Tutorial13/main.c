#include <io.h>
#include <stdint.h>

#include "system.h"
#include "sys/alt_stdio.h"
#include "sys/alt_sys_wrappers.h"

void VGAClear(uint32_t base){
	for(int i = 0 ; i <= 0xFEF ; i++){
		IOWR_8DIRECT(base, i, ' ');
	}
}

void VGAPutChar(uint32_t base, uint8_t col, uint8_t row, char c){
	uint32_t position = row * 85 + col;
	if(position > 0xFEF) return;
	IOWR_8DIRECT(base, position, c);
}

void VGAPutCharX(uint32_t base, uint32_t position, char c){
	if(position > 0xFEF) return;
	IOWR_8DIRECT(base, position, c);
}

void VGAPutString(uint32_t base, uint8_t col, uint8_t row, char* s){
	uint32_t position = row * 85 + col;
	do{
		VGAPutCharX(base, position, *s);
		position++;
	}while(*(s++) != 0);
}

int main()
{

	VGAClear(DISPLAYVGA_0_BASE);

	VGAPutString(DISPLAYVGA_0_BASE, 45, 5, "                             .-.");
	VGAPutString(DISPLAYVGA_0_BASE, 45, 6, "(___________________________()6 `-,");
	VGAPutString(DISPLAYVGA_0_BASE, 45, 7, "(   ______________________   /''\"`");
	VGAPutString(DISPLAYVGA_0_BASE, 45, 8, "//\\\\                      //\\\\");
	VGAPutString(DISPLAYVGA_0_BASE, 45, 9, "\"\" \"\"                     \"\" \"\"");
	VGAPutString(DISPLAYVGA_0_BASE, 45, 10, "jgs");
	while(1){
		for( int i = 0 ; i < 48 ; i++ ){
			VGAPutString(DISPLAYVGA_0_BASE, 0, i, "Test VGA Intel FPGA MAX10!");
			ALT_USLEEP(500000);
			VGAPutString(DISPLAYVGA_0_BASE, 0, i, "                          ");
		}
	}

	return 0;
}
