Sub cmd_read_file()
    Dim As String file_name
    Dim As string ftype
    ' ftype = 1 ' 0 DOS Command / 1 SOS binary

    Print #2, "Input file name:"; 
    Line Input #1, file_name

    Dim As Integer f
    f = FreeFile

    Open file_name For Binary Access Read As #f
    If Err>0 Then Print #2, "Error opening the file":End

    buffer_end = LOF(f)

    Get #f, , *buffer, buffer_end

    Close #f

    Print #2, "Input file type(0:com/1:s-os):"; 
    Line Input #1, ftype

    Select Case CInt(ftype)

    Case 0
        ' NTD
        adrs_offset = &H100

    Case 1
        If buffer[0] <> &h5F Or buffer[1] <> &h53 Or buffer[2] <> &h4F Or buffer[3] <> &h53 Then
            Print #2, "Error unmatch file type":End
        End If
        If buffer[4] <> &h20 Or buffer[5] <> &h30 Or buffer[6] <> &h31 Or buffer[7] <> &h20 Then
            Print #2, "Error unmatch file type":End
        End If

        buffer_start = 18
        adrs_offset = Val("&H" + Chr(buffer[8]) + Chr(buffer[9]) + Chr(buffer[10]) + Chr(buffer[11])) - 18

        make_label(&h1FE2, call_label, 0, 0)
        make_label(&h1FC7, call_label, 2, 0)

        ' make_label(&h5A04, call_label, 0, 0)
        ' make_label(&h5d7d, call_label, 0, 0)

        Print #2, "ADRS: " + hex4(buffer_start + adrs_offset) + "-" + hex4(buffer_end + adrs_offset)

    End Select

End Sub