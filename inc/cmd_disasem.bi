SUB cmd_disasem(st AS INTEGER, ed AS INTEGER)

    IF buffer_end = 0 THEN
        RETURN
    END IF

    FOR i AS INTEGER = st TO ed - 1
        output_line = ""
        DIM AS INTEGER ln = disasem(buffer, i)
        PRINT #2, hex4(i + adrs_offset) + " " + dump4(buffer, i, ln) + " " + output_line
        i = i + ln - 1
    NEXT

END SUB
