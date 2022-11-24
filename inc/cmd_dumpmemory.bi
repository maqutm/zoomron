Sub cmd_dump_memory()

    For i As Integer = buffer_start To buffer_end - 1 Step 8
        If (buffer_end - i) < 7 Then
            Print #2, hex4(i + adrs_offset) + " " + dump8(buffer, i, (buffer_end - i) Mod 8)
        Else 
            Print #2, hex4(i + adrs_offset) + " " + dump8(buffer, i, 8)
        End If
    Next

End Sub
