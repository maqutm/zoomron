SUB cmd_read_file()
    DIM AS STRING file_name
    DIM AS STRING ft ' ftype = 1 ' 0 DOS Command / 1 SOS binary

    PRINT #2, "Input file name:"; 
    LINE INPUT #1, file_name

    IF NOT read_file(file_name) THEN RETURN

    PRINT #2, "Input file type(1:com/2:s-os/3:mzt/4:mzf):"; 
    LINE INPUT #1, ft

    SELECT CASE CAST(binary_file_type, VAL(ft))

    CASE cpm_command
        adrs_offset = &H100

    CASE sos_binary
        IF NOT read_sos_binary() THEN GOTO ERR_EXIT

    CASE mzt_format
        IF NOT read_mzt_binary() THEN GOTO ERR_EXIT

    CASE mzf_format
        IF NOT read_mzt_binary() THEN GOTO ERR_EXIT

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

FUNCTION read_file(file_name as string) AS BOOLEAN

    IF buffer_end > 0 THEN
        DEALLOCATE( buffer )
        buffer_start = 0
        buffer_end = 0
        adrs_offset = 0
    END IF

    DIM AS INTEGER f
    f = FREEFILE

    IF OPEN(file_name FOR BINARY ACCESS READ AS #f) = 0 THEN

        buffer_end = LOF(f)
        buffer = ALLOCATE( buffer_end )

        GET #f, , *buffer, buffer_end

        CLOSE #f

        RETURN TRUE

    ELSE 
        PRINT #2, "Error opening the file"
        RETURN FALSE
    END IF


END FUNCTION

FUNCTION read_sos_binary() AS BOOLEAN

    IF buffer[0] <> &h5F OR buffer[1] <> &h53 OR buffer[2] <> &h4F OR buffer[3] <> &h53 THEN
        PRINT #2, "Error unmatch file type"
        RETURN FALSE
    END IF
    IF buffer[4] <> &h20 OR buffer[5] <> &h30 OR buffer[6] <> &h31 OR buffer[7] <> &h20 THEN
        PRINT #2, "Error unmatch file type"
        RETURN FALSE
    END IF

    buffer_start = 18
    adrs_offset = VAL("&H" + CHR(buffer[8]) + CHR(buffer[9]) + CHR(buffer[10]) + CHR(buffer[11])) - 18

    make_label(&h1FE2, call_label, 0, 0)
    make_label(&h1FC7, call_label, 2, 0)

    PRINT #2, "ADRS: " + hex4(buffer_start + adrs_offset) + "-" + hex4(buffer_end + adrs_offset)

    RETURN TRUE

END FUNCTION

FUNCTION read_mzt_binary() AS BOOLEAN
    ' TDB
    RETURN TRUE

END FUNCTION

FUNCTION read_mzf_binary() AS BOOLEAN
    ' TDB
    RETURN TRUE

END FUNCTION
