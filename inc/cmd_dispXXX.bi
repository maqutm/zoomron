Sub cmd_disp_adrs()

    Print #2, "ADRS: " + hex4(buffer_start + adrs_offset) + "-" + hex4(buffer_end + adrs_offset)

End Sub

Sub cmd_disp_label()

    if adrs_wrk_cnt > 0 Then
        For i as integer = 0 to adrs_wrk_cnt - 1
            Print #2, "" + hex4(adrs_wrk(i).st) + " " + Str(adrs_wrk(i).sz) + " " + Str(adrs_wrk(i).dt) + " " + Str(adrs_wrk(i).t)
        Next
    end if 

End Sub

Sub cmd_disp_message()

    if msg_wrk_cnt > 0 Then
        For i as integer = 0 to msg_wrk_cnt - 1
            Print #2, "" + hex4(msg_wrk(i).st) + " " + hex4(msg_wrk(i).ed) + " " + Str(msg_wrk(i).t)
        Next
    end if 

End Sub