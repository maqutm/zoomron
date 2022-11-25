SUB cmd_gen_source()

    IF buffer_end = 0 THEN
        RETURN
    END IF
    
    gen_pass = 1

    FOR i AS INTEGER = buffer_start TO buffer_end - 1
        output_line = ""
        after_call_ope = FALSE
        last_call_adrs = -1
        DIM AS INTEGER ln = disasem(buffer, i)
        i = i + ln - 1

        IF after_call_ope THEN
            IF check_label(last_call_adrs) THEN
                DIM AS adrs_wrk_t adrs = search_label(last_call_adrs)
                IF (adrs.t = call_label AND adrs.sz = 2) THEN
                    make_msg(i + adrs_offset + 1, adrs.sz, word_data)
                    i = i + adrs.sz
                ELSEIF (adrs.t = call_label AND adrs.sz = 1) THEN
                    make_msg(i + adrs_offset + 1, adrs.sz, byte_data)
                    i = i + adrs.sz
                ELSEIF (adrs.t = call_label AND adrs.sz = 0) THEN
                    DIM AS INTEGER ed = search_ubyte(buffer, i + 1, adrs.dt)
                    make_msg(i + adrs_offset + 1, ed - i, msg_data)
                    i = ed
                END IF
            END IF
        END IF
    NEXT

    gen_pass = 2

    DIM AS INTEGER outf = FREEFILE
    DIM AS STRING out_file_name
    PRINT #2, "Output file name:"; 
    LINE INPUT #1, out_file_name

    OPEN out_file_name FOR OUTPUT AS #outf

    IF adrs_wrk_cnt > 0 THEN
        FOR i AS INTEGER = 0 TO adrs_wrk_cnt - 1
            IF adrs_wrk(i).st < adrs_offset OR (adrs_offset + buffer_end) < adrs_wrk(i).st THEN
                PRINT #outf, "L" + hex4(adrs_wrk(i).st) + " EQU " + hex4(adrs_wrk(i).st) + "h"
            ELSE
                ' if adrs_wrk(i).t = direct_access Then
                ' else if adrs_wrk(i).t = direct_access_8 Then
                ' else 
                ' end if
            END IF
        NEXT
    END IF

    PRINT #outf, ""
    PRINT #outf, "    ORG " + hex4(buffer_start + adrs_offset) + "h"
    PRINT #outf, ""

    FOR i AS INTEGER = buffer_start TO buffer_end - 1

        DIM AS BOOLEAN lbl = check_label(i + adrs_offset)
        IF lbl THEN
            PRINT #outf, "L" + hex4(i + adrs_offset) + ":"
        END IF

        output_line = ""
        after_call_ope = FALSE
        last_call_adrs = -1

        IF check_msg(i + adrs_offset) THEN
            DIM AS msg_wrk_t msg = search_msg(i + adrs_offset)

            IF msg.t = byte_data THEN
                PRINT #outf, "    DB " + make_numeric_constant(buffer[i])
            ELSEIF msg.t = word_data THEN
                PRINT #outf, "    DW " + make_numeric_constant(buffer[i] + buffer[i + 1] * 256)
            ELSEIF msg.t = msg_data THEN
                PRINT #outf, "    DB " + make_message(buffer, i, msg.ed - msg.st)
            ELSEIF msg.t = zero_data THEN
                PRINT #outf, "    DS " + STR(msg.ed - msg.st + 1)
            END IF 
            i = msg.ed - adrs_offset
        ELSE 
            DIM AS INTEGER ln = disasem(buffer, i)
            PRINT #outf, "    " + output_line
            i = i + ln - 1
        END IF
    NEXT

    PRINT #outf, "    END"
    PRINT #outf, ""

    CLOSE #outf

END SUB