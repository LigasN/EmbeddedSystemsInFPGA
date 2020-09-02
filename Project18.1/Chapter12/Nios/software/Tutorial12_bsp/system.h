/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'CPU' in SOPC Builder design 'tutorial'
 * SOPC Builder design path: ../../tutorial.sopcinfo
 *
 * Generated: Tue Aug 25 23:38:42 CEST 2020
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00010820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x11
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x00008020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x11
#define ALT_CPU_NAME "CPU"
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x00008000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00010820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x11
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x00008020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x11
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x00008000


/*
 * CPU_ID configuration
 *
 */

#define ALT_MODULE_CLASS_CPU_ID altera_avalon_sysid_qsys
#define CPU_ID_BASE 0x110a0
#define CPU_ID_ID 0
#define CPU_ID_IRQ -1
#define CPU_ID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define CPU_ID_NAME "/dev/CPU_ID"
#define CPU_ID_SPAN 8
#define CPU_ID_TIMESTAMP 1549152546
#define CPU_ID_TYPE "altera_avalon_sysid_qsys"


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SPI
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_TIMER
#define __ALTERA_NIOS2_GEN2
#define __ALTPLL


/*
 * JATG_UART configuration
 *
 */

#define ALT_MODULE_CLASS_JATG_UART altera_avalon_jtag_uart
#define JATG_UART_BASE 0x110a8
#define JATG_UART_IRQ 0
#define JATG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JATG_UART_NAME "/dev/JATG_UART"
#define JATG_UART_READ_DEPTH 64
#define JATG_UART_READ_THRESHOLD 8
#define JATG_UART_SPAN 8
#define JATG_UART_TYPE "altera_avalon_jtag_uart"
#define JATG_UART_WRITE_DEPTH 64
#define JATG_UART_WRITE_THRESHOLD 8


/*
 * LED configuration
 *
 */

#define ALT_MODULE_CLASS_LED altera_avalon_pio
#define LED_BASE 0x11060
#define LED_BIT_CLEARING_EDGE_REGISTER 0
#define LED_BIT_MODIFYING_OUTPUT_REGISTER 1
#define LED_CAPTURE 0
#define LED_DATA_WIDTH 4
#define LED_DO_TEST_BENCH_WIRING 0
#define LED_DRIVEN_SIM_VALUE 0
#define LED_EDGE_TYPE "NONE"
#define LED_FREQ 50000000
#define LED_HAS_IN 0
#define LED_HAS_OUT 1
#define LED_HAS_TRI 0
#define LED_IRQ -1
#define LED_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED_IRQ_TYPE "NONE"
#define LED_NAME "/dev/LED"
#define LED_RESET_VALUE 10
#define LED_SPAN 32
#define LED_TYPE "altera_avalon_pio"


/*
 * PLL configuration
 *
 */

#define ALT_MODULE_CLASS_PLL altpll
#define PLL_BASE 0x11090
#define PLL_IRQ -1
#define PLL_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PLL_NAME "/dev/PLL"
#define PLL_SPAN 16
#define PLL_TYPE "altpll"


/*
 * RAM configuration
 *
 */

#define ALT_MODULE_CLASS_RAM altera_avalon_onchip_memory2
#define RAM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define RAM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define RAM_BASE 0x8000
#define RAM_CONTENTS_INFO ""
#define RAM_DUAL_PORT 0
#define RAM_GUI_RAM_BLOCK_TYPE "AUTO"
#define RAM_INIT_CONTENTS_FILE "tutorial_RAM"
#define RAM_INIT_MEM_CONTENT 0
#define RAM_INSTANCE_ID "NONE"
#define RAM_IRQ -1
#define RAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define RAM_NAME "/dev/RAM"
#define RAM_NON_DEFAULT_INIT_FILE_ENABLED 0
#define RAM_RAM_BLOCK_TYPE "AUTO"
#define RAM_READ_DURING_WRITE_MODE "DONT_CARE"
#define RAM_SINGLE_CLOCK_OP 0
#define RAM_SIZE_MULTIPLE 1
#define RAM_SIZE_VALUE 32768
#define RAM_SPAN 32768
#define RAM_TYPE "altera_avalon_onchip_memory2"
#define RAM_WRITABLE 1


/*
 * SD_DET configuration
 *
 */

#define ALT_MODULE_CLASS_SD_DET altera_avalon_pio
#define SD_DET_BASE 0x11080
#define SD_DET_BIT_CLEARING_EDGE_REGISTER 0
#define SD_DET_BIT_MODIFYING_OUTPUT_REGISTER 0
#define SD_DET_CAPTURE 0
#define SD_DET_DATA_WIDTH 2
#define SD_DET_DO_TEST_BENCH_WIRING 0
#define SD_DET_DRIVEN_SIM_VALUE 0
#define SD_DET_EDGE_TYPE "NONE"
#define SD_DET_FREQ 50000000
#define SD_DET_HAS_IN 1
#define SD_DET_HAS_OUT 0
#define SD_DET_HAS_TRI 0
#define SD_DET_IRQ -1
#define SD_DET_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SD_DET_IRQ_TYPE "NONE"
#define SD_DET_NAME "/dev/SD_DET"
#define SD_DET_RESET_VALUE 0
#define SD_DET_SPAN 16
#define SD_DET_TYPE "altera_avalon_pio"


/*
 * SD_SPI configuration
 *
 */

#define ALT_MODULE_CLASS_SD_SPI altera_avalon_spi
#define SD_SPI_BASE 0x11000
#define SD_SPI_CLOCKMULT 1
#define SD_SPI_CLOCKPHASE 0
#define SD_SPI_CLOCKPOLARITY 0
#define SD_SPI_CLOCKUNITS "Hz"
#define SD_SPI_DATABITS 8
#define SD_SPI_DATAWIDTH 16
#define SD_SPI_DELAYMULT "1.0E-9"
#define SD_SPI_DELAYUNITS "ns"
#define SD_SPI_EXTRADELAY 0
#define SD_SPI_INSERT_SYNC 0
#define SD_SPI_IRQ 3
#define SD_SPI_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SD_SPI_ISMASTER 1
#define SD_SPI_LSBFIRST 0
#define SD_SPI_NAME "/dev/SD_SPI"
#define SD_SPI_NUMSLAVES 1
#define SD_SPI_PREFIX "spi_"
#define SD_SPI_SPAN 32
#define SD_SPI_SYNC_REG_DEPTH 2
#define SD_SPI_TARGETCLOCK 500000u
#define SD_SPI_TARGETSSDELAY "0.0"
#define SD_SPI_TYPE "altera_avalon_spi"


/*
 * SD_TIMER configuration
 *
 */

#define ALT_MODULE_CLASS_SD_TIMER altera_avalon_timer
#define SD_TIMER_ALWAYS_RUN 1
#define SD_TIMER_BASE 0x11020
#define SD_TIMER_COUNTER_SIZE 32
#define SD_TIMER_FIXED_PERIOD 1
#define SD_TIMER_FREQ 50000000
#define SD_TIMER_IRQ 2
#define SD_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SD_TIMER_LOAD_VALUE 499999
#define SD_TIMER_MULT 0.001
#define SD_TIMER_NAME "/dev/SD_TIMER"
#define SD_TIMER_PERIOD 10
#define SD_TIMER_PERIOD_UNITS "ms"
#define SD_TIMER_RESET_OUTPUT 0
#define SD_TIMER_SNAPSHOT 0
#define SD_TIMER_SPAN 32
#define SD_TIMER_TICKS_PER_SEC 100
#define SD_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define SD_TIMER_TYPE "altera_avalon_timer"


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "MAX 10"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/JATG_UART"
#define ALT_STDERR_BASE 0x110a8
#define ALT_STDERR_DEV JATG_UART
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/JATG_UART"
#define ALT_STDIN_BASE 0x110a8
#define ALT_STDIN_DEV JATG_UART
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/JATG_UART"
#define ALT_STDOUT_BASE 0x110a8
#define ALT_STDOUT_DEV JATG_UART
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "tutorial"


/*
 * TIMER0 configuration
 *
 */

#define ALT_MODULE_CLASS_TIMER0 altera_avalon_timer
#define TIMER0_ALWAYS_RUN 0
#define TIMER0_BASE 0x11040
#define TIMER0_COUNTER_SIZE 32
#define TIMER0_FIXED_PERIOD 0
#define TIMER0_FREQ 50000000
#define TIMER0_IRQ 1
#define TIMER0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define TIMER0_LOAD_VALUE 49999
#define TIMER0_MULT 0.001
#define TIMER0_NAME "/dev/TIMER0"
#define TIMER0_PERIOD 1
#define TIMER0_PERIOD_UNITS "ms"
#define TIMER0_RESET_OUTPUT 0
#define TIMER0_SNAPSHOT 1
#define TIMER0_SPAN 32
#define TIMER0_TICKS_PER_SEC 1000
#define TIMER0_TIMEOUT_PULSE_OUTPUT 0
#define TIMER0_TYPE "altera_avalon_timer"


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 4
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none

#endif /* __SYSTEM_H_ */
