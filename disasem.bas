#include "inc/declare.bi"
#include "inc/memory.bi"
#include "inc/label.bi"
#include "inc/message.bi"
#include "inc/disasem_share.bi"
#include "inc/disasem.bi"
#include "inc/disasem_cb.bi"
#include "inc/disasem_ixy.bi"
#include "inc/disasem_ed.bi"
#include "inc/disasem_ixy_cb.bi"
#include "inc/disasem_util.bi"
#include "inc/cmd_readfile.bi"
#include "inc/cmd_dumpmemory.bi"
#include "inc/cmd_disasem.bi"
#include "inc/cmd_gensource.bi"
#include "inc/cmd_setlabel.bi"
#include "inc/cmd_setmessage.bi"
#include "inc/cmd_dispXXX.bi"

buffer = Allocate( buffer_size )

buffer_start = 0
buffer_end = 0

Open Cons For Input As #1
Open Cons For Output As #2

Dim as string Com = ""
DO

    Print #2, "Execute command:"; 
    Line Input #1, Com

    Select Case Left(Com, 1)
    Case "L"
        cmd_read_file

    Case "0"
        cmd_dump_memory

    Case "1"
        cmd_disasem

    Case "2"
        cmd_gen_source

    Case "A"
        cmd_set_label

    Case "B"
        cmd_set_message

    Case "X"
        cmd_disp_adrs

    Case "Y"        
        cmd_disp_label

    Case "Z"
        cmd_disp_message

    Case "Q"
        Exit DO

    End Select
LOOP

deallocate( buffer )
Print #2, "end."

Close
'sleep
