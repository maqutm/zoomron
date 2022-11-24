Sub cmd_disasem()

        For i As Integer = buffer_start To buffer_end - 1
            output_line = ""
            Dim As Integer ln = disasem(buffer, i)
            Print #2, hex4(i + adrs_offset) + " " + dump4(buffer, i, ln) + " " + output_line
            i = i + ln - 1
        Next

End Sub
