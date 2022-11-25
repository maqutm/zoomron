SUB cmd_read_file()
    DIM AS STRING file_name
    DIM AS STRING ft ' ftype = 1 ' 0 DOS Command / 1 SOS binary

    IF buffer_end > 0 THEN
        DEALLOCATE( buffer )
        buffer_start = 0
        buffer_end = 0
        adrs_offset = 0
    END IF

    PRINT #2, "Input file name:"; 
    LINE INPUT #1, file_name

    DIM AS INTEGER f
    f = FREEFILE

    OPEN file_name FOR BINARY ACCESS READ AS #f
    IF Err>0 THEN 
        PRINT #2, "Error opening the file"
        RETURN
    END IF

    buffer_end = LOF(f)
    buffer = ALLOCATE( buffer_end )

    GET #f, , *buffer, buffer_end

    CLOSE #f

    PRINT #2, "Input file type(0:com/1:s-os):"; 
    LINE INPUT #1, ft

    SELECT CASE CINT(ft)

    CASE 0
        adrs_offset = &H100

    CASE 1
        IF buffer[0] <> &h5F OR buffer[1] <> &h53 OR buffer[2] <> &h4F OR buffer[3] <> &h53 THEN
            PRINT #2, "Error unmatch file type"
            GOTO ERR_EXIT
        END IF
        IF buffer[4] <> &h20 OR buffer[5] <> &h30 OR buffer[6] <> &h31 OR buffer[7] <> &h20 THEN
            PRINT #2, "Error unmatch file type"
            GOTO ERR_EXIT
        END IF

        buffer_start = 18
        adrs_offset = VAL("&H" + CHR(buffer[8]) + CHR(buffer[9]) + CHR(buffer[10]) + CHR(buffer[11])) - 18

        make_label(&h1FE2, call_label, 0, 0)
        make_label(&h1FC7, call_label, 2, 0)

        ' make_label(&h5A04, call_label, 0, 0)
        ' make_label(&h5d7d, call_label, 0, 0)

        PRINT #2, "ADRS: " + hex4(buffer_start + adrs_offset) + "-" + hex4(buffer_end + adrs_offset)

    END SELECT

    ftype = CINT(ft)

    RETURN

ERR_EXIT:
    DEALLOCATE( buffer )
    buffer_start = 0
    buffer_end = 0
    adrs_offset = 0
    ftype = -1

END SUB