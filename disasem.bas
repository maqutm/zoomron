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
#INCLUDE "inc/cmd_loadlabel.bi"
#INCLUDE "inc/cmd_loadmessage.bi"
#INCLUDE "inc/cmd_savelabel.bi"
#INCLUDE "inc/cmd_savemessage.bi"
#INCLUDE "inc/cmd_dispXXX.bi"

OPEN CONS FOR INPUT AS #1
OPEN CONS FOR OUTPUT AS #2

DIM AS STRING COM = ""
DIM AS STRING p0, p1, p2, n
DIM AS STRING file_name

DO
    PRINT #2, "Execute command:"; 
    LINE INPUT #1, COM

    SELECT CASE LEFT(COM, 1)
    CASE "L"
        PRINT #2, "Input file name:"; 
        LINE INPUT #1, file_name

        PRINT #2, "Input file type(1:com/2:s-os/3:mzt/4:mzf):"; 
        LINE INPUT #1, p0

        cmd_read_file(file_name, CAST(binary_file_type, VAL(p0)))

    CASE "0"
        cmd_dump_memory(buffer_start, buffer_end)

    CASE "1"
        cmd_disasem(buffer_start, buffer_end)

    CASE "2"
        PRINT #2, "Output file name:"; 
        LINE INPUT #1, file_name

        cmd_gen_source(file_name)

    CASE "A"
        PRINT #2, "LBL name:";
        LINE INPUT #1, n
        PRINT #2, "LBL start:";
        LINE INPUT #1, p0
        PRINT #2, "LBL size ('':labal only,0:search data):";
        LINE INPUT #1, p1
        IF p1 = "" THEN
            cmd_set_label(VAL("&h" + p0), jp_label, 0, 0, n)
        ELSE
            PRINT #2, "LBL data :";
            LINE INPUT #1, p2
            cmd_set_label(VAL("&h" + p0), call_label, VAL(p1), VAL(p2), n)
        END IF
    
    CASE "B"
        PRINT #2, "MSG name:";
        LINE INPUT #1, n
        PRINT #2, "MSG start:";
        LINE INPUT #1, p0
        PRINT #2, "MSG type (1:byte,2:word,3:string,4:zero):";
        LINE INPUT #1, p2
        IF p1 = "1" THEN
            cmd_set_label(VAL("&h" + p0), direct_access_8, 0, 0, n)
        ELSE IF p2 = "2" THEN
            cmd_set_label(VAL("&h" + p0), direct_access, 0, 0, n)
        ELSE IF p2 = "3" OR p2 = "4" THEN
            PRINT #2, "MSG end  :";
            LINE INPUT #1, p1
            cmd_set_message(VAL("&h" + p0), VAL("&h" + p1) - VAL("&h" + p0), CAST(msg_type, VAL(p2)))
            cmd_set_label(VAL("&h" + p0), direct_access_8, 0, 0, n)
        END IF

    CASE "C"
        PRINT #2, "Input file name:"; 
        LINE INPUT #1, file_name

        cmd_load_label(file_name)

    CASE "D"
        PRINT #2, "Input file name:"; 
        LINE INPUT #1, file_name

        cmd_load_message(file_name)

    CASE "E"
        PRINT #2, "Output file name:"; 
        LINE INPUT #1, file_name

        cmd_save_label(file_name)

    CASE "F"
        PRINT #2, "Output file name:"; 
        LINE INPUT #1, file_name

        cmd_save_message(file_name)

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
