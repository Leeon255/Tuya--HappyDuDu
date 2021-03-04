; ========================================================================================================================
; * Created by: Holtek Touch Key Workshop, Version 3.0.2.6
; MAIN_PROGRAM_V101.inc
; 05:48:27 PM Friday, October 24, 2014
; =========================================================================================================;;***********************************
;;***** MAIN_PROGRAM INCLUDE FILE   *
;;***********************************
;=-------------------------------
;=INCLUDE LIBRARY               -
;=EXTERNAL REFERENCE FILE       -
;=-------------------------------
INCLUDE "..\TKS_GLOBE_VARIES.INC"
INCLUDE "MAIN_PROGRAM_20171116.MCU"

        ;-FUNCTION DEFINE               ;-FUNCTION NAME
INCLUDE "..\BS86D12C_LIBV413\BS86D12C_LIBV413.AEX"
#DEFINE EXTEND_FUNCTION_1A_INITIAL      _BS86D12C_LIBV413_INITIAL
#DEFINE EXTEND_FUNCTION_1A              _BS86D12C_LIBV413

;--
;INCLUDE "..\UART_TEST\UART_TEST.AEX"
;#DEFINE EXTEND_FUNCTION_1B_INITIAL      _UART_TEST_INITIAL
;#DEFINE EXTEND_FUNCTION_1B              _UART_TEST

INCLUDE "..\HXT_EDITOR_V100\HXT_EDITOR_V100.AEX"
#DEFINE EXTEND_FUNCTION_1B_INITIAL      _HXT_EDITOR_V100_INITIAL
#DEFINE EXTEND_FUNCTION_1B              _HXT_EDITOR_V100

;--
INCLUDE "..\USER_PROGRAM\USER_PROGRAM.AEX"
#DEFINE EXTEND_FUNCTION_1D_INITIAL      _USER_PROGRAM_INITIAL
#DEFINE EXTEND_FUNCTION_1D              _USER_PROGRAM
