Sub cmd_gen_source()

    gen_pass = 1

    For i As Integer = buffer_start To buffer_end - 1
        output_line = ""
        after_call_ope = False
        last_call_adrs = -1
        Dim As Integer ln = disasem(buffer, i)
        i = i + ln - 1

        if after_call_ope Then
            if check_label(last_call_adrs) Then
                dim as adrs_wrk_t adrs = search_label(last_call_adrs)
                if (adrs.t = call_label and adrs.sz = 2) Then
                    make_msg(i + adrs_offset + 1, adrs.sz, word_data)
                    i = i + adrs.sz
                elseif (adrs.t = call_label and adrs.sz = 1) Then
                    make_msg(i + adrs_offset + 1, adrs.sz, byte_data)
                    i = i + adrs.sz
                elseIf (adrs.t = call_label and adrs.sz = 0) Then
                    dim as integer ed = search_ubyte(buffer, i + 1, adrs.dt)
                    make_msg(i + adrs_offset + 1, ed - i, msg_data)
                    i = ed
                end if
            end if
        end if
    Next

    gen_pass = 2

    Dim as integer outf = FreeFile
    Print #2, "Output file name:"; 
    Line Input #1, out_file_name

    Open out_file_name For Output As #outf

    if adrs_wrk_cnt > 0 Then
        For i as integer = 0 to adrs_wrk_cnt - 1
            if adrs_wrk(i).st < adrs_offset or (adrs_offset + buffer_end) < adrs_wrk(i).st Then
                Print #outf, "L" + hex4(adrs_wrk(i).st) + " EQU " + hex4(adrs_wrk(i).st) + "h"
            else
                ' if adrs_wrk(i).t = direct_access Then
                ' else if adrs_wrk(i).t = direct_access_8 Then
                ' else 
                ' end if
            end if
        next
    end if

    Print #outf, ""
    Print #outf, "    ORG " + hex4(buffer_start + adrs_offset) + "h"
    Print #outf, ""

    For i as integer = buffer_start to buffer_end - 1

        dim as Boolean lbl = check_label(i + adrs_offset)
        if lbl Then
            Print #outf, "L" + hex4(i + adrs_offset) + ":"
        end if

        output_line = ""
        after_call_ope = False
        last_call_adrs = -1

        if check_msg(i + adrs_offset) Then
            dim as msg_wrk_t msg = search_msg(i + adrs_offset)
            ' Print #2, ":" + hex4(i + adrs_offset) + " " + hex4(msg.st) + " " + hex4(msg.ed) + " " + Str(msg.t)

            if msg.t = byte_data Then
                Print #outf, "    DB " + make_numeric_constant(buffer[i])
            elseIf msg.t = word_data Then
                Print #outf, "    DW " + make_numeric_constant(buffer[i] + buffer[i + 1] * 256)
            elseIf msg.t = msg_data Then
                Print #outf, "    DB " + make_message(buffer, i, msg.ed - msg.st)
            elseIf msg.t = zero_data Then
                Print #outf, "    DS " + Str(msg.ed - msg.st + 1)
            end if 
            i = msg.ed - adrs_offset
        else 
            dim as integer ln = disasem(buffer, i)
            Print #outf, "    " + output_line
            i = i + ln - 1
        end if
    Next

    Print #outf, "    END"
    Print #outf, ""

    Close #outf

End Sub