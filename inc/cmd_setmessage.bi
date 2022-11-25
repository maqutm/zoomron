SUB cmd_set_message()

    DIM AS STRING m0, m1, m2
    PRINT #2, "MSG start:";
    LINE INPUT #1, m0
    PRINT #2, "MSG end  :";
    LINE INPUT #1, m1
    PRINT #2, "MSG type :";
    LINE INPUT #1, m2
    
    make_msg(VAL("&h" + m0), VAL("&h" + m1) - VAL("&h" + m0), CAST(msg_type, VAL(m2)))

END SUB