
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R5
	.DEF _j=R4
	.DEF _index=R6
	.DEF _index_msb=R7
	.DEF _level=R8
	.DEF _level_msb=R9
	.DEF _show_level=R10
	.DEF _show_level_msb=R11
	.DEF _red=R12
	.DEF _red_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x1,0x0
	.DB  0x1,0x0,0x14,0x0

_0x3:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90
_0x4:
	.DB  0xFE,0xFD,0xFB,0xF7
_0x5:
	.DB  0x14
_0x6:
	.DB  0x14
_0x1F:
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x48,0x65,0x6C,0x6C,0x6F,0x2C,0x57,0x65
	.DB  0x6C,0x63,0x6F,0x6D,0x65,0x20,0x74,0x6F
	.DB  0x0,0x54,0x52,0x41,0x46,0x46,0x49,0x43
	.DB  0x20,0x4C,0x49,0x47,0x48,0x54,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x54,0x69,0x6D
	.DB  0x65,0x20,0x52,0x65,0x64,0x0,0x6D,0x61
	.DB  0x78,0x3D,0x36,0x30,0x30,0x3A,0x0,0x57
	.DB  0x65,0x6C,0x6C,0x20,0x44,0x6F,0x6E,0x65
	.DB  0x20,0x21,0x0,0x4E,0x65,0x78,0x74,0x20
	.DB  0x73,0x74,0x65,0x70,0x0,0x45,0x6E,0x74
	.DB  0x65,0x72,0x20,0x54,0x69,0x6D,0x65,0x20
	.DB  0x59,0x65,0x6C,0x6F,0x77,0x0,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x54,0x69,0x6D,0x65
	.DB  0x20,0x47,0x72,0x65,0x65,0x6E,0x0,0x41
	.DB  0x6C,0x6C,0x20,0x72,0x69,0x67,0x68,0x74
	.DB  0x0,0x70,0x72,0x65,0x73,0x73,0x20,0x62
	.DB  0x75,0x74,0x74,0x6F,0x6E,0x0,0x43,0x6F
	.DB  0x75,0x6E,0x74,0x69,0x6E,0x67,0x20,0x52
	.DB  0x65,0x64,0x0,0x25,0x64,0x20,0x2F,0x20
	.DB  0x25,0x64,0x0,0x43,0x6F,0x75,0x6E,0x74
	.DB  0x69,0x6E,0x67,0x20,0x79,0x65,0x6C,0x6C
	.DB  0x6F,0x77,0x0,0x43,0x6F,0x75,0x6E,0x74
	.DB  0x69,0x6E,0x67,0x20,0x67,0x72,0x65,0x65
	.DB  0x6E,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _data
	.DW  _0x3*2

	.DW  0x04
	.DW  _row
	.DW  _0x4*2

	.DW  0x01
	.DW  _yellow
	.DW  _0x5*2

	.DW  0x01
	.DW  _green
	.DW  _0x6*2

	.DW  0x11
	.DW  _0x20
	.DW  _0x0*2

	.DW  0x0E
	.DW  _0x20+17
	.DW  _0x0*2+17

	.DW  0x0F
	.DW  _0x20+31
	.DW  _0x0*2+31

	.DW  0x09
	.DW  _0x20+46
	.DW  _0x0*2+46

	.DW  0x0C
	.DW  _0x20+55
	.DW  _0x0*2+55

	.DW  0x0A
	.DW  _0x20+67
	.DW  _0x0*2+67

	.DW  0x11
	.DW  _0x20+77
	.DW  _0x0*2+77

	.DW  0x09
	.DW  _0x20+94
	.DW  _0x0*2+46

	.DW  0x0C
	.DW  _0x20+103
	.DW  _0x0*2+55

	.DW  0x0A
	.DW  _0x20+115
	.DW  _0x0*2+67

	.DW  0x11
	.DW  _0x20+125
	.DW  _0x0*2+94

	.DW  0x09
	.DW  _0x20+142
	.DW  _0x0*2+46

	.DW  0x0A
	.DW  _0x20+151
	.DW  _0x0*2+111

	.DW  0x0D
	.DW  _0x20+161
	.DW  _0x0*2+121

	.DW  0x0D
	.DW  _0x20+174
	.DW  _0x0*2+134

	.DW  0x10
	.DW  _0x20+187
	.DW  _0x0*2+155

	.DW  0x0F
	.DW  _0x20+203
	.DW  _0x0*2+171

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <math.h>
;#include <stdio.h>
;
;unsigned char data[10] = {0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90},

	.DSEG
;row[] ={0xFE,0xFD,0xFb,0xF7} ,
;i,j,num[16];
;int index = 0;
;int level = 1, show_level = 1;
;int red = 20, tempRed = 0, yellow= 20, tempYellow = 0, green= 20, tempGreen = 0, k = 0;
;
;unsigned char get_input(){
; 0000 000E unsigned char get_input(){

	.CSEG
_get_input:
; .FSTART _get_input
; 0000 000F 
; 0000 0010       char result = '*';
; 0000 0011 
; 0000 0012       unsigned char column = 3;
; 0000 0013 
; 0000 0014       while(1){
	ST   -Y,R17
	ST   -Y,R16
;	result -> R17
;	column -> R16
	LDI  R17,42
	LDI  R16,3
_0x7:
; 0000 0015             for (i = 0; i < 4; i++)
	CLR  R5
_0xB:
	LDI  R30,LOW(4)
	CP   R5,R30
	BRSH _0xC
; 0000 0016             {
; 0000 0017                  PORTB = row[i];
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_row)
	SBCI R31,HIGH(-_row)
	LD   R30,Z
	OUT  0x18,R30
; 0000 0018                  while(PINB.4 == 0) column = 0;
_0xD:
	SBIC 0x16,4
	RJMP _0xF
	LDI  R16,LOW(0)
	RJMP _0xD
_0xF:
; 0000 0019 while(PINB.5 == 0) column = 1;
_0x10:
	SBIC 0x16,5
	RJMP _0x12
	LDI  R16,LOW(1)
	RJMP _0x10
_0x12:
; 0000 001A while(PINB.6 == 0) column = 2;
_0x13:
	SBIC 0x16,6
	RJMP _0x15
	LDI  R16,LOW(2)
	RJMP _0x13
_0x15:
; 0000 001B while(column != 3){
	CPI  R16,3
	BREQ _0x18
; 0000 001C                  result = ( i * 3 + column);
	MOV  R30,R5
	LDI  R26,LOW(3)
	MULS R30,R26
	MOVW R30,R0
	ADD  R30,R16
	MOV  R17,R30
; 0000 001D                  if(result == 10){
	CPI  R17,10
	BRNE _0x19
; 0000 001E                  result = -1;
	LDI  R17,LOW(255)
; 0000 001F                  }else if(result == 9){
	RJMP _0x1A
_0x19:
	CPI  R17,9
	BRNE _0x1B
; 0000 0020                      if(index > 0){
	CLR  R0
	CP   R0,R6
	CPC  R0,R7
	BRGE _0x1C
; 0000 0021                      index--;
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0000 0022                      result = 11;
	LDI  R17,LOW(11)
; 0000 0023                      }
; 0000 0024                  }else if(result == 11){
_0x1C:
	RJMP _0x1D
_0x1B:
	CPI  R17,11
	BRNE _0x1E
; 0000 0025                      result = 13;
	LDI  R17,LOW(13)
; 0000 0026                  }
; 0000 0027                  column = 3;
_0x1E:
_0x1D:
_0x1A:
	LDI  R16,LOW(3)
; 0000 0028                  return result;
	MOV  R30,R17
	RJMP _0x20C0007
; 0000 0029                  }
_0x18:
; 0000 002A             }
	INC  R5
	RJMP _0xB
_0xC:
; 0000 002B       }
	RJMP _0x7
; 0000 002C }
_0x20C0007:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void main(void)
; 0000 002F {
_main:
; .FSTART _main
; 0000 0030 char inp, buffer[16];;
; 0000 0031 int sum = 0, num1 = 0, num2 = 0, num3 = 0, temp_num2, counter = 1;
; 0000 0032 int start_flag = 0;
; 0000 0033 DDRB = 0x0F;
	SBIW R28,26
	LDI  R24,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x1F*2)
	LDI  R31,HIGH(_0x1F*2)
	CALL __INITLOCB
;	inp -> R17
;	buffer -> Y+10
;	sum -> R18,R19
;	num1 -> R20,R21
;	num2 -> Y+8
;	num3 -> Y+6
;	temp_num2 -> Y+4
;	counter -> Y+2
;	start_flag -> Y+0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0034 PORTB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0035 DDRC = 0xFF;
	OUT  0x14,R30
; 0000 0036 PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0037 DDRD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0038 PORTD = 0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0039 
; 0000 003A lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 003B lcd_clear();
	CALL _lcd_clear
; 0000 003C lcd_gotoxy(0,0);
	CALL SUBOPT_0x0
; 0000 003D lcd_puts("Hello,Welcome to");
	__POINTW2MN _0x20,0
	CALL _lcd_puts
; 0000 003E lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x1
; 0000 003F lcd_puts("TRAFFIC LIGHT");
	__POINTW2MN _0x20,17
	CALL _lcd_puts
; 0000 0040 delay_ms(10);
	CALL SUBOPT_0x2
; 0000 0041 lcd_clear();
	CALL _lcd_clear
; 0000 0042 
; 0000 0043 
; 0000 0044 
; 0000 0045 while (1)
_0x21:
; 0000 0046       {
; 0000 0047       if(level == 1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BREQ PC+2
	RJMP _0x24
; 0000 0048           lcd_gotoxy(0,0);
	CALL SUBOPT_0x0
; 0000 0049           lcd_puts("Enter Time Red");
	__POINTW2MN _0x20,31
	CALL SUBOPT_0x3
; 0000 004A           lcd_gotoxy(0,1);
; 0000 004B           lcd_puts("max=600:");
	__POINTW2MN _0x20,46
	CALL SUBOPT_0x4
; 0000 004C           inp = get_input();
; 0000 004D           if(inp == 11){
	BRNE _0x25
; 0000 004E             num[index] = ' ';
	CALL SUBOPT_0x5
	ST   X,R30
; 0000 004F           }else if(inp == 13){
	RJMP _0x26
_0x25:
	CPI  R17,13
	BRNE _0x27
; 0000 0050             lcd_clear();
	CALL SUBOPT_0x6
; 0000 0051             lcd_gotoxy(3,0);
; 0000 0052             lcd_puts("Well Done !");
	__POINTW2MN _0x20,55
	CALL SUBOPT_0x7
; 0000 0053             lcd_gotoxy(3,1);
; 0000 0054             lcd_puts("Next step");
	__POINTW2MN _0x20,67
	CALL _lcd_puts
; 0000 0055             level++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0056             for (k = 0; k < index; k++){
	CALL SUBOPT_0x8
_0x29:
	CALL SUBOPT_0x9
	BRGE _0x2A
; 0000 0057                 if(k == 0){
	CALL SUBOPT_0xA
	SBIW R30,0
	BRNE _0x2B
; 0000 0058                     sum = (num[k]-48);
	CALL SUBOPT_0xB
	SBIW R30,48
	RJMP _0x68
; 0000 0059                 }else{
_0x2B:
; 0000 005A                     sum = sum * pow(10,1) + (num[k]-47);
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
_0x68:
	MOVW R18,R30
; 0000 005B                 }
; 0000 005C             }
	CALL SUBOPT_0xE
	RJMP _0x29
_0x2A:
; 0000 005D             delay_ms(10);
	CALL SUBOPT_0x2
; 0000 005E             for (j=0; j <= index; j++)
	CLR  R4
_0x2E:
	CALL SUBOPT_0xF
	BRLT _0x2F
; 0000 005F             num[j] = ' ';
	CALL SUBOPT_0x10
	INC  R4
	RJMP _0x2E
_0x2F:
; 0000 0060 index = 0;
	CLR  R6
	CLR  R7
; 0000 0061             red = sum;
	MOVW R12,R18
; 0000 0062             lcd_clear();
	CALL _lcd_clear
; 0000 0063           }
; 0000 0064           else{
	RJMP _0x30
_0x27:
; 0000 0065 
; 0000 0066             num[index] = (char) (inp + 49);
	MOVW R26,R6
	SUBI R26,LOW(-_num)
	SBCI R27,HIGH(-_num)
	MOV  R30,R17
	SUBI R30,-LOW(49)
	ST   X,R30
; 0000 0067             index++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0068 
; 0000 0069           }
_0x30:
_0x26:
; 0000 006A           lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x1
; 0000 006B           lcd_puts(num);
	CALL SUBOPT_0x11
; 0000 006C           }
; 0000 006D       else if(level == 2){
	RJMP _0x31
_0x24:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	BREQ PC+2
	RJMP _0x32
; 0000 006E           lcd_gotoxy(0,0);
	CALL SUBOPT_0x0
; 0000 006F           lcd_puts("Enter Time Yelow");
	__POINTW2MN _0x20,77
	CALL SUBOPT_0x3
; 0000 0070           lcd_gotoxy(0,1);
; 0000 0071           lcd_puts("max=600:");
	__POINTW2MN _0x20,94
	CALL SUBOPT_0x4
; 0000 0072           inp = get_input();
; 0000 0073           if(inp == 11){
	BRNE _0x33
; 0000 0074             num[index] = ' ';
	CALL SUBOPT_0x5
	RJMP _0x69
; 0000 0075           }else if(inp == 13){
_0x33:
	CPI  R17,13
	BRNE _0x35
; 0000 0076             lcd_clear();
	CALL SUBOPT_0x6
; 0000 0077             lcd_gotoxy(3,0);
; 0000 0078             lcd_puts("Well Done !");
	__POINTW2MN _0x20,103
	CALL SUBOPT_0x7
; 0000 0079             lcd_gotoxy(3,1);
; 0000 007A             lcd_puts("Next step");
	__POINTW2MN _0x20,115
	CALL _lcd_puts
; 0000 007B             level++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 007C             delay_ms(10);
	CALL SUBOPT_0x2
; 0000 007D             sum = 0;
	__GETWRN 18,19,0
; 0000 007E             for (k = 0; k < index; k++){
	CALL SUBOPT_0x8
_0x37:
	CALL SUBOPT_0x9
	BRGE _0x38
; 0000 007F                 if(k == 0){
	CALL SUBOPT_0xA
	SBIW R30,0
	BRNE _0x39
; 0000 0080                     sum = (num[k]-48);
	CALL SUBOPT_0xB
	SBIW R30,48
	RJMP _0x6A
; 0000 0081                 }else{
_0x39:
; 0000 0082                     sum = sum * pow(10,1) + (num[k]-47);
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
_0x6A:
	MOVW R18,R30
; 0000 0083                 }
; 0000 0084             }
	CALL SUBOPT_0xE
	RJMP _0x37
_0x38:
; 0000 0085             yellow = sum;
	__PUTWMRN _yellow,0,18,19
; 0000 0086             for (j=0; j <= index; j++)
	CLR  R4
_0x3C:
	CALL SUBOPT_0xF
	BRLT _0x3D
; 0000 0087             num[j] = ' ';
	CALL SUBOPT_0x10
	INC  R4
	RJMP _0x3C
_0x3D:
; 0000 0088 index = 0;
	CLR  R6
	CLR  R7
; 0000 0089             lcd_clear();
	RCALL _lcd_clear
; 0000 008A           }
; 0000 008B           else{
	RJMP _0x3E
_0x35:
; 0000 008C             num[index++] = (char) (inp + 49);
	CALL SUBOPT_0x12
_0x69:
	ST   X,R30
; 0000 008D           }
_0x3E:
; 0000 008E           lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x1
; 0000 008F           lcd_puts(num);
	CALL SUBOPT_0x11
; 0000 0090        }
; 0000 0091        else if(level == 3){
	RJMP _0x3F
_0x32:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	BREQ PC+2
	RJMP _0x40
; 0000 0092           lcd_gotoxy(0,0);
	CALL SUBOPT_0x0
; 0000 0093           lcd_puts("Enter Time Green");
	__POINTW2MN _0x20,125
	CALL SUBOPT_0x3
; 0000 0094           lcd_gotoxy(0,1);
; 0000 0095           lcd_puts("max=600:");
	__POINTW2MN _0x20,142
	CALL SUBOPT_0x4
; 0000 0096           inp =  get_input();
; 0000 0097           if(inp == 11){
	BRNE _0x41
; 0000 0098             num[index] = ' ';
	CALL SUBOPT_0x5
	RJMP _0x6B
; 0000 0099           }else if(inp == 13){
_0x41:
	CPI  R17,13
	BRNE _0x43
; 0000 009A             level++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 009B             delay_ms(10);
	CALL SUBOPT_0x2
; 0000 009C             sum = 0;
	__GETWRN 18,19,0
; 0000 009D             for (k = 0; k < index; k++){
	CALL SUBOPT_0x8
_0x45:
	CALL SUBOPT_0x9
	BRGE _0x46
; 0000 009E                 if(k == 0){
	CALL SUBOPT_0xA
	SBIW R30,0
	BRNE _0x47
; 0000 009F                     sum = (num[k]-48);
	CALL SUBOPT_0xB
	SBIW R30,48
	RJMP _0x6C
; 0000 00A0                 }else{
_0x47:
; 0000 00A1                     sum = sum * pow(10,1) + (num[k]-47);
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
_0x6C:
	MOVW R18,R30
; 0000 00A2                 }
; 0000 00A3             }
	CALL SUBOPT_0xE
	RJMP _0x45
_0x46:
; 0000 00A4             green = sum;
	__PUTWMRN _green,0,18,19
; 0000 00A5             for (j=0; j <= index; j++)
	CLR  R4
_0x4A:
	CALL SUBOPT_0xF
	BRLT _0x4B
; 0000 00A6             num[j] = ' ';
	CALL SUBOPT_0x10
	INC  R4
	RJMP _0x4A
_0x4B:
; 0000 00A7 index = 0;
	CLR  R6
	CLR  R7
; 0000 00A8             lcd_clear();
	RCALL _lcd_clear
; 0000 00A9             lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1
; 0000 00AA             lcd_puts("All right");
	__POINTW2MN _0x20,151
	RCALL _lcd_puts
; 0000 00AB             lcd_gotoxy(0,0);
	CALL SUBOPT_0x0
; 0000 00AC             lcd_puts("press button");
	__POINTW2MN _0x20,161
	RCALL _lcd_puts
; 0000 00AD           }
; 0000 00AE           else{
	RJMP _0x4C
_0x43:
; 0000 00AF             num[index++] = (char) (inp + 49);
	CALL SUBOPT_0x12
_0x6B:
	ST   X,R30
; 0000 00B0           }
_0x4C:
; 0000 00B1           lcd_gotoxy(9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x1
; 0000 00B2           lcd_puts(num);
	CALL SUBOPT_0x11
; 0000 00B3        }
; 0000 00B4 
; 0000 00B5        else if(level == 4){
	RJMP _0x4D
_0x40:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R8
	CPC  R31,R9
	BREQ PC+2
	RJMP _0x4E
; 0000 00B6             if(PINB.7 == 0){
	SBIC 0x16,7
	RJMP _0x4F
; 0000 00B7               if(start_flag == 0) {
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x50
; 0000 00B8                   start_flag = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   Y,R30
	STD  Y+1,R31
; 0000 00B9                   delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 00BA                   tempRed = red;
	__PUTWMRN _tempRed,0,12,13
; 0000 00BB               }
; 0000 00BC               else{
	RJMP _0x51
_0x50:
; 0000 00BD                   start_flag = 0;
	LDI  R30,LOW(0)
	STD  Y+0,R30
	STD  Y+0+1,R30
; 0000 00BE                   delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 00BF               }
_0x51:
; 0000 00C0             }
; 0000 00C1                 if(show_level == 1 && start_flag == 1){
_0x4F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x53
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BREQ _0x54
_0x53:
	RJMP _0x52
_0x54:
; 0000 00C2                     lcd_clear();
	CALL SUBOPT_0x13
; 0000 00C3                     lcd_gotoxy(1,0);
; 0000 00C4                     lcd_puts("Counting Red");
	__POINTW2MN _0x20,174
	CALL SUBOPT_0x7
; 0000 00C5                     lcd_gotoxy(3,1);
; 0000 00C6                     sprintf(buffer,"%d / %d",counter++, red);
	CALL SUBOPT_0x14
	MOVW R30,R12
	CALL SUBOPT_0x15
; 0000 00C7                     lcd_puts(buffer);
; 0000 00C8                     tempYellow = yellow;
	LDS  R30,_yellow
	LDS  R31,_yellow+1
	STS  _tempYellow,R30
	STS  _tempYellow+1,R31
; 0000 00C9 
; 0000 00CA                     num3 = tempRed / 100;
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 00CB                     temp_num2 = tempRed % 100;
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 00CC                     num2 = temp_num2 / 10;
; 0000 00CD                     num1 = temp_num2 % 10;
; 0000 00CE 
; 0000 00CF                   for(j = 0 ; j < 25 ; j++){
_0x56:
	LDI  R30,LOW(25)
	CP   R4,R30
	BRSH _0x57
; 0000 00D0 
; 0000 00D1                     PORTC = 0x11;
	LDI  R30,LOW(17)
	CALL SUBOPT_0x19
; 0000 00D2                     PORTD = data[0];
; 0000 00D3                     delay_ms(3);
; 0000 00D4 
; 0000 00D5                     PORTC = 0x21;
	LDI  R30,LOW(33)
	CALL SUBOPT_0x1A
; 0000 00D6                     PORTD = data[num3];
; 0000 00D7                     delay_ms(3);
; 0000 00D8 
; 0000 00D9                     PORTC = 0x41;
	LDI  R30,LOW(65)
	CALL SUBOPT_0x1B
; 0000 00DA                     PORTD = data[num2];
; 0000 00DB                     delay_ms(3);
; 0000 00DC 
; 0000 00DD                     PORTC = 0x81;
	LDI  R30,LOW(129)
	CALL SUBOPT_0x1C
; 0000 00DE                     PORTD = data[num1];
; 0000 00DF                     delay_ms(3);
; 0000 00E0 
; 0000 00E1 
; 0000 00E2                   }
	INC  R4
	RJMP _0x56
_0x57:
; 0000 00E3 
; 0000 00E4                   tempRed--;
	LDI  R26,LOW(_tempRed)
	LDI  R27,HIGH(_tempRed)
	CALL SUBOPT_0x1D
; 0000 00E5                   if(tempRed == 0){
	LDS  R30,_tempRed
	LDS  R31,_tempRed+1
	SBIW R30,0
	BRNE _0x58
; 0000 00E6                   show_level++;
	CALL SUBOPT_0x1E
; 0000 00E7                   counter = 1;
; 0000 00E8                   }
; 0000 00E9 
; 0000 00EA               }
_0x58:
; 0000 00EB 
; 0000 00EC               if(show_level == 2 && start_flag == 1){
_0x52:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x5A
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BREQ _0x5B
_0x5A:
	RJMP _0x59
_0x5B:
; 0000 00ED                     lcd_clear();
	CALL SUBOPT_0x13
; 0000 00EE                     lcd_gotoxy(1,0);
; 0000 00EF                     lcd_puts("Counting yellow");
	__POINTW2MN _0x20,187
	CALL SUBOPT_0x7
; 0000 00F0                     lcd_gotoxy(3,1);
; 0000 00F1                     sprintf(buffer,"%d / %d",counter++, yellow);
	CALL SUBOPT_0x14
	LDS  R30,_yellow
	LDS  R31,_yellow+1
	CALL SUBOPT_0x15
; 0000 00F2                     lcd_puts(buffer);
; 0000 00F3                     tempGreen = green;
	LDS  R30,_green
	LDS  R31,_green+1
	STS  _tempGreen,R30
	STS  _tempGreen+1,R31
; 0000 00F4 
; 0000 00F5                     num3 = tempYellow / 100;
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x17
; 0000 00F6                     temp_num2 = tempYellow % 100;
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x18
; 0000 00F7                     num2 = temp_num2 / 10;
; 0000 00F8                     num1 = temp_num2 % 10;
; 0000 00F9 
; 0000 00FA                   for(j = 0 ; j < 25 ; j++){
_0x5D:
	LDI  R30,LOW(25)
	CP   R4,R30
	BRSH _0x5E
; 0000 00FB 
; 0000 00FC                     PORTC = 0x12;
	LDI  R30,LOW(18)
	CALL SUBOPT_0x19
; 0000 00FD                     PORTD = data[0];
; 0000 00FE                     delay_ms(3);
; 0000 00FF 
; 0000 0100                     PORTC = 0x22;
	LDI  R30,LOW(34)
	CALL SUBOPT_0x1A
; 0000 0101                     PORTD = data[num3];
; 0000 0102                     delay_ms(3);
; 0000 0103 
; 0000 0104                     PORTC = 0x42;
	LDI  R30,LOW(66)
	CALL SUBOPT_0x1B
; 0000 0105                     PORTD = data[num2];
; 0000 0106                     delay_ms(3);
; 0000 0107 
; 0000 0108                     PORTC = 0x82;
	LDI  R30,LOW(130)
	CALL SUBOPT_0x1C
; 0000 0109                     PORTD = data[num1];
; 0000 010A                     delay_ms(3);
; 0000 010B 
; 0000 010C 
; 0000 010D                   }
	INC  R4
	RJMP _0x5D
_0x5E:
; 0000 010E 
; 0000 010F                   tempYellow--;
	LDI  R26,LOW(_tempYellow)
	LDI  R27,HIGH(_tempYellow)
	CALL SUBOPT_0x1D
; 0000 0110                   if(tempYellow == 0){
	LDS  R30,_tempYellow
	LDS  R31,_tempYellow+1
	SBIW R30,0
	BRNE _0x5F
; 0000 0111                   show_level++;
	CALL SUBOPT_0x1E
; 0000 0112                   counter = 1;
; 0000 0113                   }
; 0000 0114 
; 0000 0115               }
_0x5F:
; 0000 0116 
; 0000 0117               if(show_level == 3 && start_flag == 1){
_0x59:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x61
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BREQ _0x62
_0x61:
	RJMP _0x60
_0x62:
; 0000 0118                     lcd_clear();
	CALL SUBOPT_0x13
; 0000 0119                     lcd_gotoxy(1,0);
; 0000 011A                     lcd_puts("Counting green");
	__POINTW2MN _0x20,203
	CALL SUBOPT_0x7
; 0000 011B                     lcd_gotoxy(3,1);
; 0000 011C                     sprintf(buffer,"%d / %d",counter++, green);
	CALL SUBOPT_0x14
	LDS  R30,_green
	LDS  R31,_green+1
	CALL SUBOPT_0x15
; 0000 011D                     lcd_puts(buffer);
; 0000 011E                     tempRed = red;
	__PUTWMRN _tempRed,0,12,13
; 0000 011F 
; 0000 0120                     num3 = tempGreen / 100;
	CALL SUBOPT_0x20
	CALL SUBOPT_0x17
; 0000 0121                     temp_num2 = tempGreen % 100;
	CALL SUBOPT_0x20
	CALL SUBOPT_0x18
; 0000 0122                     num2 = temp_num2 / 10;
; 0000 0123                     num1 = temp_num2 % 10;
; 0000 0124 
; 0000 0125                   for(j = 0 ; j < 25 ; j++){
_0x64:
	LDI  R30,LOW(25)
	CP   R4,R30
	BRSH _0x65
; 0000 0126 
; 0000 0127                     PORTC = 0x14;
	LDI  R30,LOW(20)
	CALL SUBOPT_0x19
; 0000 0128                     PORTD = data[0];
; 0000 0129                     delay_ms(3);
; 0000 012A 
; 0000 012B                     PORTC = 0x24;
	LDI  R30,LOW(36)
	CALL SUBOPT_0x1A
; 0000 012C                     PORTD = data[num3];
; 0000 012D                     delay_ms(3);
; 0000 012E 
; 0000 012F                     PORTC = 0x44;
	LDI  R30,LOW(68)
	CALL SUBOPT_0x1B
; 0000 0130                     PORTD = data[num2];
; 0000 0131                     delay_ms(3);
; 0000 0132 
; 0000 0133                     PORTC = 0x84;
	LDI  R30,LOW(132)
	CALL SUBOPT_0x1C
; 0000 0134                     PORTD = data[num1];
; 0000 0135                     delay_ms(3);
; 0000 0136 
; 0000 0137 
; 0000 0138                   }
	INC  R4
	RJMP _0x64
_0x65:
; 0000 0139 
; 0000 013A                   tempGreen--;
	LDI  R26,LOW(_tempGreen)
	LDI  R27,HIGH(_tempGreen)
	CALL SUBOPT_0x1D
; 0000 013B                   if(tempGreen == 0){
	LDS  R30,_tempGreen
	LDS  R31,_tempGreen+1
	SBIW R30,0
	BRNE _0x66
; 0000 013C                   show_level = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 013D                   counter = 1;
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 013E                   }
; 0000 013F 
; 0000 0140               }
_0x66:
; 0000 0141        }
_0x60:
; 0000 0142 
; 0000 0143       }
_0x4E:
_0x4D:
_0x3F:
_0x31:
	RJMP _0x21
; 0000 0144 }
_0x67:
	RJMP _0x67
; .FEND

	.DSEG
_0x20:
	.BYTE 0xDA
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x20C0006
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20C0006
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x21
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x21
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20C0006
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20C0006
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	CALL SUBOPT_0x22
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0006:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x23
	RJMP _0x20C0005
__floor1:
    brtc __floor0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
_0x20C0005:
	ADIW R28,4
	RET
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x25
	CALL __CPD02
	BRLT _0x202000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20C0004
_0x202000C:
	CALL SUBOPT_0x26
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x27
	CALL SUBOPT_0x25
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x202000D
	CALL SUBOPT_0x28
	CALL __ADDF12
	CALL SUBOPT_0x27
	__SUBWRN 16,17,1
_0x202000D:
	CALL SUBOPT_0x26
	CALL SUBOPT_0x24
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x26
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	__GETD2N 0x3F654226
	CALL SUBOPT_0x2A
	__GETD1N 0x4054114E
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x25
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2C
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x20C0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
; .FEND
_exp:
; .FSTART _exp
	CALL __PUTPARD2
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x2D
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x202000F
	CALL SUBOPT_0x2E
	RJMP _0x20C0003
_0x202000F:
	__GETD1S 10
	CALL __CPD10
	BRNE _0x2020010
	__GETD1N 0x3F800000
	RJMP _0x20C0003
_0x2020010:
	CALL SUBOPT_0x2D
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2020011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0003
_0x2020011:
	CALL SUBOPT_0x2D
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	__PUTD1S 10
	CALL SUBOPT_0x2D
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x2D
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x2B
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x25
	CALL __MULF12
	CALL SUBOPT_0x27
	CALL SUBOPT_0x2C
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x26
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x25
	CALL SUBOPT_0x2C
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x20C0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x2F
	CALL __CPD10
	BRNE _0x2020012
	CALL SUBOPT_0x2E
	RJMP _0x20C0002
_0x2020012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x2020013
	CALL SUBOPT_0x30
	CALL __CPD10
	BRNE _0x2020014
	__GETD1N 0x3F800000
	RJMP _0x20C0002
_0x2020014:
	__GETD2S 8
	CALL SUBOPT_0x31
	RCALL _exp
	RJMP _0x20C0002
_0x2020013:
	CALL SUBOPT_0x30
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x30
	CALL __CPD12
	BREQ _0x2020015
	CALL SUBOPT_0x2E
	RJMP _0x20C0002
_0x2020015:
	CALL SUBOPT_0x2F
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x31
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2020016
	CALL SUBOPT_0x2F
	RJMP _0x20C0002
_0x2020016:
	CALL SUBOPT_0x2F
	CALL __ANEGF1
_0x20C0002:
	ADIW R28,12
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
; .FSTART _put_buff_G102
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2040013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2040014:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R19,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x32
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R19,37
	BRNE _0x2040020
	CALL SUBOPT_0x32
	RJMP _0x20400AD
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R18,LOW(0)
	LDI  R16,LOW(0)
	CPI  R19,43
	BRNE _0x2040021
	LDI  R18,LOW(43)
	RJMP _0x204001B
_0x2040021:
	CPI  R19,32
	BRNE _0x2040022
	LDI  R18,LOW(32)
	RJMP _0x204001B
_0x2040022:
	RJMP _0x2040023
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040024
_0x2040023:
	CPI  R19,48
	BRNE _0x2040025
	ORI  R16,LOW(16)
	LDI  R17,LOW(5)
	RJMP _0x204001B
_0x2040025:
	RJMP _0x2040026
_0x2040024:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x204001B
_0x2040026:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x204002B
	CALL SUBOPT_0x33
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ICALL
	RJMP _0x204002C
_0x204002B:
	CPI  R30,LOW(0x73)
	BRNE _0x204002E
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
_0x204002F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2040031
	CALL SUBOPT_0x32
	RJMP _0x204002F
_0x2040031:
	RJMP _0x204002C
_0x204002E:
	CPI  R30,LOW(0x70)
	BRNE _0x2040033
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
_0x2040034:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2040036
	CALL SUBOPT_0x32
	RJMP _0x2040034
_0x2040036:
	RJMP _0x204002C
_0x2040033:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(1)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	RJMP _0x20400AE
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(2)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040052
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
_0x20400AE:
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBRS R16,0
	RJMP _0x2040042
	CALL SUBOPT_0x33
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R20,X+
	LD   R21,X
	TST  R21
	BRPL _0x2040043
	MOVW R30,R20
	CALL __ANEGW1
	MOVW R20,R30
	LDI  R18,LOW(45)
_0x2040043:
	CPI  R18,0
	BREQ _0x2040044
	ST   -Y,R18
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ICALL
_0x2040044:
	RJMP _0x2040045
_0x2040042:
	CALL SUBOPT_0x33
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R20,X+
	LD   R21,X
_0x2040045:
_0x2040047:
	LDI  R19,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2040049:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R20,R30
	CPC  R21,R31
	BRLO _0x204004B
	SUBI R19,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	__SUBWRR 20,21,26,27
	RJMP _0x2040049
_0x204004B:
	SBRC R16,4
	RJMP _0x204004D
	CPI  R19,49
	BRSH _0x204004D
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x204004C
_0x204004D:
	ORI  R16,LOW(16)
	CPI  R19,58
	BRLO _0x204004F
	SBRS R16,1
	RJMP _0x2040050
	SUBI R19,-LOW(7)
	RJMP _0x2040051
_0x2040050:
	SUBI R19,-LOW(39)
_0x2040051:
_0x204004F:
	CALL SUBOPT_0x32
_0x204004C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH _0x2040047
_0x2040052:
_0x204002C:
_0x20400AD:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x35
	SBIW R30,0
	BRNE _0x2040053
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2040053:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x35
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_data:
	.BYTE 0xA
_row:
	.BYTE 0x4
_num:
	.BYTE 0x10
_tempRed:
	.BYTE 0x2
_yellow:
	.BYTE 0x2
_tempYellow:
	.BYTE 0x2
_green:
	.BYTE 0x2
_tempGreen:
	.BYTE 0x2
_k:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	CALL _lcd_puts
	CALL _get_input
	MOV  R17,R30
	CPI  R17,11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_num)
	LDI  R27,HIGH(_num)
	ADD  R26,R6
	ADC  R27,R7
	LDI  R30,LOW(32)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	CALL _lcd_clear
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	CALL _lcd_puts
	LDI  R30,LOW(3)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	STS  _k,R30
	STS  _k+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDS  R26,_k
	LDS  R27,_k+1
	CP   R26,R6
	CPC  R27,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	LDS  R30,_k
	LDS  R31,_k+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xB:
	RCALL SUBOPT_0xA
	SUBI R30,LOW(-_num)
	SBCI R31,HIGH(-_num)
	LD   R30,Z
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0xC:
	__GETD1N 0x41200000
	CALL __PUTPARD1
	__GETD2N 0x3F800000
	CALL _pow
	MOVW R26,R18
	CALL __CWD2
	CALL __CDF2
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xD:
	SBIW R30,47
	CALL __CWD1
	CALL __CDF1
	CALL __ADDF12
	CALL __CFD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_k)
	LDI  R27,HIGH(_k)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	MOVW R30,R6
	MOV  R26,R4
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_num)
	SBCI R31,HIGH(-_num)
	LDI  R26,LOW(32)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_num)
	LDI  R27,HIGH(_num)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	SBIW R30,1
	SUBI R30,LOW(-_num)
	SBCI R31,HIGH(-_num)
	MOVW R26,R30
	MOV  R30,R17
	SUBI R30,-LOW(49)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	CALL _lcd_clear
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x14:
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,147
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x15:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	MOVW R26,R28
	ADIW R26,10
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDS  R26,_tempRed
	LDS  R27,_tempRed+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	CALL __DIVW21
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x18:
	CALL __MODW21
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R20,R30
	CLR  R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	OUT  0x15,R30
	LDS  R30,_data
	OUT  0x12,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1A:
	OUT  0x15,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-_data)
	SBCI R31,HIGH(-_data)
	LD   R30,Z
	OUT  0x12,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1B:
	OUT  0x15,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SUBI R30,LOW(-_data)
	SBCI R31,HIGH(-_data)
	LD   R30,Z
	OUT  0x12,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1C:
	OUT  0x15,R30
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	OUT  0x12,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	SBIW R30,1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+2,R30
	STD  Y+2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDS  R26,_tempYellow
	LDS  R27,_tempYellow+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDS  R26,_tempGreen
	LDS  R27,_tempGreen+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__GETD2N 0x3F800000
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x25:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x26:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x26
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	CALL _log
	__GETD2S 4
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x32:
	ST   -Y,R19
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x34:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
