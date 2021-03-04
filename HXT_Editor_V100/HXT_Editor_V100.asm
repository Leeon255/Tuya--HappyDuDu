message '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - '
message '<      HXT_Editor_V100.asm     >'
        INCLUDE HXT_Editor_V100.INC
PUBLIC  _HXT_Editor_V100
PUBLIC  _HXT_Editor_V100_INITIAL


        #define IIC_ADDRESS 0A0H

        ;#define IIC_TH_LEN 16

IFNDEF IIC_TH_LEN
        IFDEF	TKM7C0
        	IFNDEF _TKM_
        	#define _TKM_   8
        	ENDIF
        ENDIF
        IFDEF	TKM6C0
        	IFNDEF _TKM_
        	#define _TKM_   7
        	ENDIF
        ENDIF
        IFDEF	TKM5C0
        	IFNDEF _TKM_
        	#define _TKM_   6
        	ENDIF
        ENDIF
        IFDEF	TKM4C0
        	IFNDEF _TKM_
        	#define _TKM_   5
        	ENDIF
        ENDIF
        IFDEF	TKM3C0
        	IFNDEF _TKM_
        	#define _TKM_   4
        	ENDIF
        ENDIF
        IFDEF	TKM2C0
        	IFNDEF _TKM_
        	#define _TKM_   3
        	ENDIF
        ENDIF
        IFDEF	TKM1C0
        	IFNDEF _TKM_
        	#define _TKM_   2
        	ENDIF
        ENDIF
        IFDEF	TKM0C0
        	IFNDEF _TKM_
        	#define _TKM_   1
        	ENDIF
        ENDIF



        IFNDEF  _TKM_
            ERRmessage  '_TKM_ Not define'
        ELSE
            #define IIC_TH_LEN  (_TKM_*4)
        ENDIF
ENDIF





;*******************************************************************
#define CMD_R_Lib_VersionL  00H
#define CMD_R_Lib_VersionH  01H
#define CMD_R_KeyAmount 02H
#define CMD_R_EE_Status 03H
#define CMD_R_TK_Select0    04H
#define CMD_R_KeyStatus0    08H
#define CMD_R_K1_Freq   010H
#define CMD_R_K1_Ref    050H
#define CMD_R_K1_Offset 090H
#define CMD_R_K1_RCC    0B0H

#define CMD_RW_Global   0D0H
#define CMD_RW_DeviceA  CMD_RW_Global+0
#define CMD_RW_DeviceB  CMD_RW_Global+1
#define CMD_RW_KeyAmount    CMD_RW_Global+2
#define CMD_RW_OptionA  CMD_RW_Global+3
#define CMD_RW_OptionB  CMD_RW_Global+4
#define CMD_RW_OptionC  CMD_RW_Global+5
;#define    CMD_RW_     CMD_RW_Global+6
;#define    CMD_RW_     CMD_RW_Global+7
#define CMD_RW_K1_TH    CMD_RW_Global+8


;;;;;#define    CMD_R_Lib_VersionL  00H
;;;;;#define    CMD_R_Lib_VersionH  01H
;;;;;#define    CMD_R_KeyAmount 02H
;;;;;#define    CMD_R_EE_Status 03H
;;;;;#define    CMD_R_TK_Select0    04H
;;;;;#define    CMD_R_KeyStatus0    08H
;;;;;#define    CMD_R_K1_Freq   010H
;;;;;#define    CMD_R_K1_Ref    050H
;;;;;#define    CMD_R_K1_RCC    090H
;;;;;
;;;;;#define    CMD_RW_Global   0B0H
;;;;;#define    CMD_RW_B0       CMD_RW_Global+0
;;;;;#define    CMD_RW_B1       CMD_RW_Global+1
;;;;;#define    CMD_RW_OptionA  CMD_RW_Global+2
;;;;;#define    CMD_RW_OptionB  CMD_RW_Global+3
;;;;;#define    CMD_RW_OptionC  CMD_RW_Global+4
;;;;;#define    CMD_RW_K1_TH    CMD_RW_Global+5
;*********************************************************************





;;;;;;*******************************************************************
RAMBANK 0 IIC_SLAVE_TEST_RW_RAM
IIC_SLAVE_TEST_RW_RAM       .SECTION  'DATA'
IIC_STACK   DB 2 DUP(?)
;*******************************************************************
IIC_SLAVE_TEST_RW_CODE    .SECTION  'CODE'
;;;;;IIC_WRITE_ENTRY PROC
;;;;;        JMP END_IIC_RW
;;;;;IIC_WRITE_ENTRY ENDP
;================================================================

;*******************************************************************

;*******************************************************************
IIC_PRE_READ PROC
        MOV     A,MP1
        MOV     IIC_STACK[0],A
        MOV     A,BP
        MOV     IIC_STACK[1],A
        CLR     IIC_DATA_OUT
;================================================================

        MOV     A,IIC_DATA_INDEX
        SUB     A,CMD_RW_K1_TH
        SZ      C
        JMP     IIC_READ_KEY_TH

        MOV     A,IIC_DATA_INDEX
        SUB     A,CMD_RW_Global
        SZ      C
        JMP     IIC_READ_Setting

        MOV     A,IIC_DATA_INDEX
        SUB     A,CMD_R_K1_RCC
        SZ      C
        JMP     IIC_READ_RCC

        MOV     A,IIC_DATA_INDEX
        SUB     A,CMD_R_K1_OFFSET
        SZ      C
        JMP     END_IIC_RW

        MOV     A,IIC_DATA_INDEX
        SUB     A,CMD_R_K1_Ref
        SZ      C
        JMP     IIC_READ_REF

        MOV     A,IIC_DATA_INDEX
        SUB     A,CMD_R_K1_Freq
        SZ      C
        JMP     IIC_READ_FREQ

        MOV     A,IIC_DATA_INDEX
        SUB     A,CMD_R_KeyStatus0
        SZ      C
        JMP     IIC_READ_STATUS

        MOV     A,IIC_DATA_INDEX
        SUB     A,CMD_R_TK_Select0
        SZ      C
        JMP     IIC_READ_TK_SEL

        MOV     A,IIC_DATA_INDEX
        XOR     A,CMD_R_EE_Status
        SNZ     Z
        JMP     $+4
        MOV     A,0
        MOV     IIC_DATA_OUT,A
        JMP     END_IIC_RW

        MOV     A,IIC_DATA_INDEX
        XOR     A,CMD_R_KeyAmount
        SNZ     Z
        JMP     $0
        MOV     A,IIC_TH_LEN
        MOV     IIC_DATA_OUT,A
        JMP     END_IIC_RW
    $0:
        MOV     A,IIC_DATA_INDEX
        XOR     A,CMD_R_Lib_VersionH
        SNZ     Z
        JMP     $1
        MOV     A,IIC_LibVer[1]
        MOV     IIC_DATA_OUT,A
        JMP     END_IIC_RW
    $1:
        SZ      IIC_DATA_INDEX
        JMP     END_IIC_RW
        MOV     A,IIC_LibVer[0]
        MOV     IIC_DATA_OUT,A
        JMP     END_IIC_RW
    IIC_READ_KEY_TH:
                ADD     A,OFFSET        _GLOBE_VARIES+3
                MOV     MP1,A
                MOV     A,BANK  _GLOBE_VARIES
                MOV     BP,A
                JMP     IIC_PRELOAD_DATA
    IIC_READ_Setting:
                ADD     A,OFFSET        _GLOBE_VARIES
                MOV     MP1,A
                MOV     A,BANK  _GLOBE_VARIES
                MOV     BP,A
                JMP     IIC_PRELOAD_DATA
    IIC_READ_STATUS:
                ADD     A,OFFSET    _KEY_DATA
                MOV     MP1,A
                MOV     A,BANK  _KEY_DATA
                MOV     BP,A
                JMP     IIC_PRELOAD_DATA
    IIC_READ_TK_SEL:
                ADD     A,OFFSET    _KEY_IO_SEL
                MOV     MP1,A
                MOV     A,BANK  _KEY_IO_SEL
                MOV     BP,A

                MOV     A,IAR1
                XOR     A,0FFH
                MOV     IIC_DATA_OUT,A
                JMP     END_IIC_RW

    IIC_READ_RCC:
                RL      ACC
                RL      ACC
                ;;ADD A,3
                ADD     A,OFFSET    _KEY_REF + 3
                MOV     MP1,A
                MOV     A,BANK  _KEY_REF
                MOV     BP,A
                JMP     IIC_PRELOAD_DATA
                    ;----------------
    IIC_READ_FREQ:  ;-READ KEY FREQ -
                    ;----------------
                RL      ACC
                ADD     A,OFFSET    _KEY_REF + 1
                ;; INC ACC
                MOV     MP1,A
                MOV     A,BANK  _KEY_REF
                MOV     BP,A

                ;....V412.....
                ;ADD    A,OFFSET    _KEY_FREQ
                ;MOV    MP1,A
                ;MOV    A,BANK  _KEY_FREQ
                ;MOV    BP,A
                ;.............

                JMP     IIC_READ_FREQ_REF
                    ;----------------
    IIC_READ_REF:   ;-READ REFERENCE-
                    ;----------------
                RL      ACC
                AND     A,11111100B
                ADD     A,OFFSET    _KEY_REF
                MOV     MP1,A
                MOV     A,BANK  _KEY_REF
                MOV     BP,A
        IIC_READ_FREQ_REF:
                SZ      IIC_DATA_INDEX.0
                JMP     IIC_READ_FREQ_REF_HIGH_BYTE
                MOV     A,IAR1
                MOV     IIC_DATA_OUT,A

                ;....V412.....
                ;INC    MP1
                ;MOV    A,IAR1
                ;MOV    IIC_DATA_IN,A
                ;.............
                JMP END_IIC_RW
        IIC_READ_FREQ_REF_HIGH_BYTE:
                ;....V412.....
                ;MOV    A,IIC_DATA_IN
                ;AND    A,0FH
                ;MOV    IIC_DATA_OUT,A
                ;.............

                ;....V413.....
                CLR     IIC_DATA_OUT
                ;.............

                JMP     END_IIC_RW
    IIC_PRELOAD_DATA:;-IIC PRE-LOAD DATA
                MOV     A,IAR1
                MOV     IIC_DATA_OUT,A
;================================================================
END_IIC_RW:
        MOV     A,IIC_STACK[1]
        MOV     BP,A
        MOV     A,IIC_STACK[0]
        MOV     MP1,A
        JMP     _ENDIIC
IIC_PRE_READ ENDP
;*******************************************************************















































;*************************************************************************************************************************************************
;*************************************************************************************************************************************************
;*************************************************************************************************************************************************
;*************************************************************************************************************************************************
;*************************************************************************************************************************************************
;*************************************************************************************************************************************************
;*************************************************************************************************************************************************
;*************************************************************************************************************************************************


IFDEF   SIMCTL0
    #define SIMC0   SIMCTL0
endif
ifdef   IICC0
    #define SIMC0   IICC0
endif

IFDEF   SIMAR
    #define SIMA    SIMAR
endif
IFDEF   IICA
    #define SIMA    IICA
endif

IFDEF   SIMDR
    #define SIMD    SIMDR
endif
IFDEF   IICD
    #define SIMD    IICD
ENDIF

IFDEF   ESIMI
    #define SIME    ESIMI
endif
IFDEF   IICE
    #define SIME    IICE
endif

ifdef   IICF
    #define SIMF    IICF
ENDIF


ifdef   IICHTX
    #define HTX IICHTX
endif
ifdef   IICHAAS
    #define HAAS    IICHAAS
endif
ifdef   IICSRW
    #define SRW IICSRW
endif
ifdef   IICRXAK
    #define RXAK    IICRXAK
endif
ifdef   IICTXAK
    #define TXAK    IICTXAK
endif

ifdef   IICRNIC
    #define RNIC    IICRNIC
ENDIF






RAMBANK 0 HXT_Editor_V100_RAM
HXT_Editor_V100_RAM       .SECTION  'DATA'
SIM_STACK       DB 2 DUP(?)
bWrite1st       DBIT
IIC_DATA_OUT    DB      ?
IIC_DATA_IN DB      ?
IIC_DATA_INDEX  DB      ?
IIC_LibVer  DB  2   DUP(?)
;=====================================================================





;*********************************************************************
#define SlaveMode       HTX
#define AddrMatch       HAAS
#define MasterRead  SRW
#define SlaveRecAck RXAK
DUMMY_READ  macro
        MOV A,SIMD      ;DUMMY READ
        endm
SLAVE_SEND_ACK  macro           ;enable transmits acknowledge
        CLR TXAK
        endm
Slave_Tx_Mode   macro
        set SlaveMode
        endm
Slave_Rx_Mode   macro           ;receive mode (master write)
        clr SlaveMode
        endm

IF_AddrNotMatch_GOTO    macro   addr
        SNZ AddrMatch       ;0:read/write data 1:address match
        JMP addr
        endm

IF_WriteData_GOTO   macro   addr
        SNZ MasterRead  ;0:master wants to write data 1:master wants to read data
        JMP addr
        endm

IF_Master_Read_GOTO macro   addr
        SZ  SlaveMode
        JMP addr
        endm
IF_ACK_GOTO macro   addr
        SNZ SlaveRecAck
        JMP addr
        endm

;*********************************************************************
IIC_INT_CODE   .SECTION  AT IIC_INT_ADDR 'CODE'
        CHECK_SIMF
        CLR     SIMF
        JMP     SIM_INT

HXT_Editor_V100_CODE    .SECTION  'CODE'
IIC_INITIAL PROC
;JMP    IIC_WRITE_ENTRY
;jmp    IIC_PRE_READ

        SET     IIC_SDA_PU
        SET     IIC_SCL_PU
        ;--
        MOV     A,11000010B ;I2C Mode ,Enable SIM
        MOV     SIMC0,A


        MOV     A,IIC_ADDRESS
        MOV     SIMA,A

        CLR     HTX
        CLR     TXAK
        SET     RNIC
        ;--
        CLR     SIMF        ;Clear SIM interrupt request flag

        MOV     A,10111111B ;Enable I2C Time-out Countrol
        MOV     I2CTOC,A              ;I2C time-out time is 64*32/32K = 62.5mSec

        SET     SIME
	INIT_IIC_IO
        RET
IIC_INITIAL ENDP







;*******************************************************************
_HXT_Editor_V100:
        SZ      I2CTOF
        CALL    IIC_INITIAL
        RET
;*******************************************************************


;*******************************************************************
_HXT_Editor_V100_INITIAL:
        CALL    IIC_INITIAL
        CALL    _GET_LIB_VER
        MOV     IIC_LibVer[1],A
        MOV     A,_DATA_BUF[0]
        MOV     IIC_LibVer[0],A
        RET
;*******************************************************************












;;***********************************************************
;;*SUB. NAME:                                               *
;;*INPUT    :                                               *
;;*OUTPUT   :                                               *
;;*USED REG.:                                               *
;;*FUNCTION :                                               *
;;***********************************************************
                ;;*******************
SIM_INT:        ;;* SIM INT. ********
                ;;*******************
        CLR     SIMF
        ;-PUSH DATA
        MOV     SIM_STACK[0],A
        MOV     A,STATUS
        MOV     SIM_STACK[1],A

        ;-CHECK IF ADDRESS MATCH
        IF_AddrNotMatch_GOTO    IIC_CONTINUE_RW
        IF_WriteData_GOTO   FIRST_WRITE
        ;-FIRST READ (PREPARE DATA)
        Slave_Tx_Mode
        JMP     IIC_CONTINUE_READ
    IIC_CONTINUE_RW:
        IF_Master_Read_GOTO IIC_MASTER_READ
        ;-MASTER WRITE
        MOV     A,SIMD
        MOV     IIC_DATA_IN,A
        SZ      bWrite1st
;;;;;        JMP IIC_WRITE_ENTRY
        JMP     _ENDIIC

        MOV     IIC_DATA_INDEX,A    ;-GET 1ST BYTE (ADDRESS)
        SET     bWrite1st
        JMP     IIC_PRE_READ    ;PR-READ DATA
    FIRST_WRITE:
        CLR     bWrite1st
        JMP     SIM_RECEIVE_MODE
    IIC_MASTER_READ:
        IF_ACK_GOTO IIC_CONTINUE_READ
        ;NACK
    SIM_RECEIVE_MODE:
        Slave_Rx_Mode       ;receive mode (master write)
        SLAVE_SEND_ACK      ;enable transmits acknowledge
        DUMMY_READ
    _ENDIIC:
        MOV     A,SIM_STACK[1]
        MOV     STATUS,A
        MOV     A,SIM_STACK[0]
        RETI
;*******************************************************************
IIC_CONTINUE_READ:
        MOV     A,IIC_DATA_OUT
        MOV     SIMD,A
        INC     IIC_DATA_INDEX
        JMP     IIC_PRE_READ
;*******************************************************************
message '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - '
