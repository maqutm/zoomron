SUB cmd_save_message(out_file_name AS STRING)

    DIM AS INTEGER outf = FREEFILE

    IF OPEN(out_file_name FOR OUTPUT AS #outf) = 0 THEN
        FOR i AS INTEGER = 0 TO msg_wrk_cnt -1
            PRINT #outf, hex4(msg_wrk(i).st) + ":" + hex4(msg_wrk(i).ed) + ":" + STR(msg_wrk(i).t)
        NEXT
    END IF              

    CLOSE #outf

END SUB