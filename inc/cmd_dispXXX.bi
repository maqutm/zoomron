SUB cmd_disp_adrs()

    IF buffer_end = 0 THEN
        RETURN
    END IF

    PRINT #2, "ADRS: " + hex4(buffer_start + adrs_offset) + "-" + hex4(buffer_end + adrs_offset)

END SUB

SUB cmd_disp_label()

    IF adrs_wrk_cnt > 0 THEN
        FOR i AS INTEGER = 0 TO adrs_wrk_cnt - 1
            PRINT #2, "" + hex4(adrs_wrk(i).st) + " " + STR(adrs_wrk(i).sz) + " " + STR(adrs_wrk(i).dt) + " " + STR(adrs_wrk(i).t)
        NEXT
    END IF 

END SUB

SUB cmd_disp_message()

    IF msg_wrk_cnt > 0 THEN
        FOR i AS INTEGER = 0 TO msg_wrk_cnt - 1
            PRINT #2, "" + hex4(msg_wrk(i).st) + " " + hex4(msg_wrk(i).ed) + " " + STR(msg_wrk(i).t)
        NEXT
    END IF 

END SUB