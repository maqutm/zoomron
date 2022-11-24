Sub cmd_set_label()

    Dim as string l0, l1, l2
    Print #2, "LBL start:";
    Line Input #1, l0
    Print #2, "LBL size :";
    Line Input #1, l1
    Print #2, "LBL data :";
    Line Input #1, l2
    
    make_label(Val("&h" + l0), call_label, Val(l1), Val(l2))

End Sub
