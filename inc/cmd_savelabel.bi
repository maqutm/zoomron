SUB cmd_save_label(out_file_name AS STRING)

    DIM AS INTEGER outf = FREEFILE

    IF OPEN(out_file_name FOR OUTPUT AS #outf) = 0 THEN
        FOR i AS INTEGER = 0 TO adrs_wrk_cnt -1
            PRINT #outf, hex4(adrs_wrk(i).st) + ":" + hex4(adrs_wrk(i).sz) + ":" + hex4(adrs_wrk(i).dt) + ":" + STR(adrs_wrk(i).t) + ":" + adrs_wrk(i).n
        NEXT
    END IF              

    CLOSE #outf

END SUB