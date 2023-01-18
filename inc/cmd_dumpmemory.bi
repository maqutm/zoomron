SUB cmd_dump_memory(st AS INTEGER, ed AS INTEGER)

    IF buffer_end = 0 THEN
        RETURN
    END IF

    FOR i AS INTEGER = st TO ed - 1 STEP 8
        IF (buffer_end - i) < 7 THEN
            PRINT #2, hex4(i + adrs_offset) + " " + dump8(buffer, i, (buffer_end - i) MOD 8)
        ELSE 
            PRINT #2, hex4(i + adrs_offset) + " " + dump8(buffer, i, 8)
        END IF
    NEXT

END SUB
