#include "system.h"
#include "sys/alt_stdio.h"

#include "altera_avalon_timer_regs.h"

#include "sys/alt_irq.h"

#include "ff.h"
#include "diskio.h"

#define BUFF_SIZE 256
BYTE Buff[BUFF_SIZE];	/* Working buffer */

FATFS Fatfs;			/* File system object for each logical drive */
FIL File;				/* File object */

void sdTimerInterrupt(void* context){
	IOWR_ALTERA_AVALON_TIMER_STATUS(SD_TIMER_BASE, 0);
	disk_timerproc();
}

UINT getLine(BYTE* line, UINT len){
	BYTE c;
	UINT i = 0;

	while(i < len){
		c = alt_getchar();
		if(c == '\n') break;
		line[i++] = c;
		//alt_putchar(c);
	}
	return i;
}

void waitUser(void){
	alt_putstr("Press any key to continue...\r\n");
	alt_getchar();
}

int main()
{ 

	alt_putstr("maXimator SD card demo\r\n");

	alt_ic_isr_register(SD_TIMER_IRQ_INTERRUPT_CONTROLLER_ID, SD_TIMER_IRQ, sdTimerInterrupt, NULL, NULL);
	IOWR_ALTERA_AVALON_TIMER_CONTROL(SD_TIMER_BASE, ALTERA_AVALON_TIMER_CONTROL_ITO_MSK);

	while(1){

		if(disk_initialize(0) != 0){  // inicjalizujemy warstwê sprzêtow¹
			alt_putstr("SD card ERROR\r\n");
			waitUser();
			continue;
		}

		alt_putstr("SD card initialized\r\n");

		if(f_mount(&Fatfs, "", 0) != FR_OK){  // inicjalizujemy system plików
			alt_putstr("File System ERROR\r\n");
			waitUser();
			continue;
		}

		alt_putstr("File system FATfs initialized\r\n");

		if(f_open(&File, "SD.txt", FA_READ|FA_OPEN_ALWAYS) != FR_OK){  // otwieramy plik do odczytu,
			// jeœli plik nie istnieje to tworzymy nowy plik
			alt_putstr("File Open for reading ERROR\r\n");
			waitUser();
			continue;
		}

		alt_putstr("File SD.txt opened for reading\r\n");

		UINT i=0;

		while(1){
			if(f_read(&File, &Buff, BUFF_SIZE, &i) == FR_OK){  // odczytujemy maksymalnie 255 znaków z pliku
				alt_printf("0x%x bytes read:\r\n", i);  // i je wyœwietlamy
				if(i == 0) break;
				UINT j = 0;
				while(j<i && Buff[j]){
					alt_putchar(Buff[j++]);
				}
				alt_putstr("\r\n");
			}else{
				alt_putstr("File Read ERROR\r\n");
				break;
			}
		}

		if(f_close(&File) != FR_OK){  // zamykamy plik
			alt_putstr("File Close ERROR\r\n");
			waitUser();
			continue;
		}

		alt_putstr("File Closed\r\n");

		alt_putstr("Save something? (Y/N): ");  // pytamy o to czy u¿ytkownik chce coœ zapisaæ

		getLine(Buff, BUFF_SIZE);

		if(Buff[0] != 'Y'){
			alt_putstr("End program\r\n");
			waitUser();
			continue;
		}

		alt_putstr("Clear file? (Y/N): ");  // oraz czy chce wyczyœciæ plik

		getLine(Buff, BUFF_SIZE);

		if(Buff[0] == 'Y'){
			if(f_open(&File, "SD.txt", FA_WRITE|FA_CREATE_ALWAYS) != FR_OK){  // jeœli chce wyczyœciæ plik to to czynimy
				alt_putstr("File Open for writing ERROR\r\n");
				waitUser();
				continue;
			}
		}else{
			if(f_open(&File, "SD.txt", FA_WRITE|FA_OPEN_APPEND) != FR_OK){  // a jeœli chce coœ dopisaæ na koñcu to otwieramy plik w odpowiednim trybie
				alt_putstr("File Open for writing ERROR\r\n");
				waitUser();
				continue;
			}
		}

		alt_putstr("File Opened for writing\r\n");


		alt_putstr("Type text to write: ");

		i = getLine(Buff, BUFF_SIZE-2);
		Buff[i++]='\r';
		Buff[i++]='\n';


		if(f_write(&File, Buff, i, &i) != FR_OK){  // i zapisujemy go do pliku
			alt_putstr("File Write ERROR\r\n");
		}

		alt_printf("0x%x bytes written\r\n", i);

		if(f_close(&File) != FR_OK){  // po czym plik zamykamy
			alt_putstr("File Close ERROR\r\n");
			waitUser();
			continue;
		}

		alt_putstr("File Closed\r\n");

		alt_putstr("End program\r\n");  // teraz mo¿na wyj¹æ kartê i pobawiæ siê na komputerze

		waitUser();
	}

	return 0;
}
