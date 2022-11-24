Sub cmd_set_message()

    Dim as string m0, m1, m2
    Print #2, "MSG start:";
    Line Input #1, m0
    Print #2, "MSG end  :";
    Line Input #1, m1
    Print #2, "MSG type :";
    Line Input #1, m2
    
    make_msg(Val("&h" + m0), Val("&h" + m1) - Val("&h" + m0), cast(msg_type, Val(m2)))

End Sub