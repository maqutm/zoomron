SUB cmd_set_label()

    DIM AS STRING l0, l1, l2
    PRINT #2, "LBL start:";
    LINE INPUT #1, l0
    PRINT #2, "LBL size :";
    LINE INPUT #1, l1
    PRINT #2, "LBL data :";
    LINE INPUT #1, l2
    
    make_label(VAL("&h" + l0), call_label, VAL(l1), VAL(l2))

END SUB
