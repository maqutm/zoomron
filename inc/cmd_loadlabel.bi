SUB cmd_load_label(in_file_name AS STRING)

    DIM AS INTEGER inf = FREEFILE
    DIM AS STRING input_line

    IF OPEN(in_file_name FOR INPUT AS #inf) = 0 THEN

        DIM i AS INTEGER = 0

        DO WHILE NOT EOF(inf)
            LINE INPUT #inf, input_line
            adrs_wrk(i).st = VAL("&h" + MID$(input_line, 1, 4))
            adrs_wrk(i).sz = VAL("&h" + MID$(input_line, 6, 4))
            adrs_wrk(i).dt = VAL("&h" + MID$(input_line, 11, 4))
            adrs_wrk(i).t = CAST(msg_type, VAL(MID$(input_line, 16, 1)))
            adrs_wrk(i).n = MID$(input_line, 18)
            i = i + 1
        LOOP

        adrs_wrk_cnt = i

        CLOSE #inf

    END IF

END SUB