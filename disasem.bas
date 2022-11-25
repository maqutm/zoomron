#INCLUDE "inc/declare.bi"
#INCLUDE "inc/memory.bi"
#INCLUDE "inc/label.bi"
#INCLUDE "inc/message.bi"
#INCLUDE "inc/disasem_share.bi"
#INCLUDE "inc/disasem.bi"
#INCLUDE "inc/disasem_cb.bi"
#INCLUDE "inc/disasem_ixy.bi"
#INCLUDE "inc/disasem_ed.bi"
#INCLUDE "inc/disasem_ixy_cb.bi"
#INCLUDE "inc/disasem_util.bi"
#INCLUDE "inc/cmd_readfile.bi"
#INCLUDE "inc/cmd_dumpmemory.bi"
#INCLUDE "inc/cmd_disasem.bi"
#INCLUDE "inc/cmd_gensource.bi"
#INCLUDE "inc/cmd_setlabel.bi"
#INCLUDE "inc/cmd_setmessage.bi"
#INCLUDE "inc/cmd_dispXXX.bi"

OPEN CONS FOR INPUT AS #1
OPEN CONS FOR OUTPUT AS #2

DIM AS STRING COM = ""
DO

    PRINT #2, "Execute command:"; 
    LINE INPUT #1, COM

    SELECT CASE LEFT(COM, 1)
    CASE "L"
        cmd_read_file

    CASE "0"
        cmd_dump_memory

    CASE "1"
        cmd_disasem

    CASE "2"
        cmd_gen_source

    CASE "A"
        cmd_set_label

    CASE "B"
        cmd_set_message

    CASE "X"
        cmd_disp_adrs

    CASE "Y"        
        cmd_disp_label

    CASE "Z"
        cmd_disp_message

    CASE "Q"
        EXIT DO

    END SELECT
LOOP

IF buffer_end > 0 THEN
    DEALLOCATE( buffer )
END IF
PRINT #2, "end."

CLOSE
'sleep
