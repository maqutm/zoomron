SUB cmd_read_file(file_name AS STRING, ft AS binary_file_type)

    IF NOT read_file(file_name) THEN RETURN

    SELECT CASE ft

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


SUB setup_cpm_binary() 


END SUB

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

    make_label(&h1F5B, direct_access_8, 0, 0, "#MXLIN")
    make_label(&h1F5C, direct_access_8, 0, 0, "#WIDTH")
    make_label(&h1F5D, direct_access_8, 0, 0, "#DSK")
    make_label(&h1F5E, direct_access, 0, 0, "#FATPS")
    make_label(&h1F60, direct_access, 0, 0, "#DIRPS")
    make_label(&h1F62, direct_access, 0, 0, "#FATBF")
    make_label(&h1F64, direct_access, 0, 0, "#DTBUF")
    make_label(&h1F66, direct_access_8, 0, 0, "#MXTRK")
    make_label(&h1F67, direct_access_8, 0, 0, "#DIRNO")
    make_label(&h1F68, direct_access, 0, 0, "#WKSIZ")
    make_label(&h1F6A, direct_access, 0, 0, "#MEMAX")
    make_label(&h1F6C, direct_access, 0, 0, "#STKAD")
    make_label(&h1F6E, direct_access, 0, 0, "#EXADR")
    make_label(&h1F70, direct_access, 0, 0, "#DTADR")
    make_label(&h1F72, direct_access, 0, 0, "#SIZE")
    make_label(&h1F74, direct_access, 0, 0, "#IBFAD")
    make_label(&h1F76, direct_access, 0, 0, "#KBFAD")
    make_label(&h1F78, direct_access, 0, 0, "#XYADR")
    make_label(&h1F7A, direct_access, 0, 0, "#PRCNT")
    make_label(&h1F7C, direct_access_8, 0, 0, "#LPSW")
    make_label(&h1F7D, direct_access_8, 0, 0, "#DVSW")
    make_label(&h1F7E, direct_access, 0, 0, "#USR")

    make_label(&h1F80, jp_label, 0, 0, "#GETPC")
    make_label(&h1F81, jp_label, 0, 0, "[HL]")
    make_label(&h1F8E, jp_label, 0, 0, "#MON")
    make_label(&h1F91, jp_label, 0, 0, "#PEEK@")
    make_label(&h1F94, jp_label, 0, 0, "#PEEK")
    make_label(&h1F97, jp_label, 0, 0, "#POKE@")
    make_label(&h1F9A, jp_label, 0, 0, "#POKE")
    make_label(&h1F9D, jp_label, 0, 0, "#FPRNT")
    make_label(&h1FA0, jp_label, 0, 0, "#FSAME")
    make_label(&h1FA3, jp_label, 0, 0, "#FILE")
    make_label(&h1FA6, jp_label, 0, 0, "#RDD")
    make_label(&h1FA9, jp_label, 0, 0, "#FCB")
    make_label(&h1FAC, jp_label, 0, 0, "#WRD")
    make_label(&h1FAF, jp_label, 0, 0, "#WOPEN")
    make_label(&h1FB2, jp_label, 0, 0, "#HLHEX")
    make_label(&h1FB5, jp_label, 0, 0, "#2HEX")
    make_label(&h1FB8, jp_label, 0, 0, "#HEX")
    make_label(&h1FBB, jp_label, 0, 0, "#ASC")
    make_label(&h1FBE, jp_label, 0, 0, "#PRTHL")
    make_label(&h1FC1, jp_label, 0, 0, "#PRTHX")
    make_label(&h1FC4, jp_label, 0, 0, "#BELL")
    make_label(&h1FC7, call_label, 2, 0, "#PAUSE")
    make_label(&h1FCA, jp_label, 0, 0, "#INKEY")
    make_label(&h1FCD, jp_label, 0, 0, "#BRKEY")
    make_label(&h1FD0, jp_label, 0, 0, "#GETKY")
    make_label(&h1FD3, jp_label, 0, 0, "#GETL")
    make_label(&h1FD6, jp_label, 0, 0, "#LPTOF")
    make_label(&h1FD9, jp_label, 0, 0, "#LPTON")
    make_label(&h1FDC, jp_label, 0, 0, "#LPRNT")
    make_label(&h1FDF, jp_label, 0, 0, "#TAB")
    make_label(&h1FE2, call_label, 0, 0, "#MPRNT")
    make_label(&h1FE5, jp_label, 0, 0, "#MSX")
    make_label(&h1FE8, jp_label, 0, 0, "#MSG")
    make_label(&h1FEB, jp_label, 0, 0, "#NL")
    make_label(&h1FEE, jp_label, 0, 0, "#LTNL")
    make_label(&h1FF1, jp_label, 0, 0, "#PRNTS")
    make_label(&h1FF4, jp_label, 0, 0, "#PRINT")
    make_label(&h1FF7, jp_label, 0, 0, "#VER")
    make_label(&h1FFA, jp_label, 0, 0, "#HOT")
    make_label(&h1FFD, jp_label, 0, 0, "#COLD")
    make_label(&h2000, jp_label, 0, 0, "#DRDSB")
    make_label(&h2003, jp_label, 0, 0, "#DWTSB")
    make_label(&h2006, jp_label, 0, 0, "#DIR")
    make_label(&h2009, jp_label, 0, 0, "#ROPEN")
    make_label(&h200C, jp_label, 0, 0, "#SET")
    make_label(&h200F, jp_label, 0, 0, "#RESET")
    make_label(&h2012, jp_label, 0, 0, "#NAME")
    make_label(&h2015, jp_label, 0, 0, "#KILL")
    make_label(&h2018, jp_label, 0, 0, "#CSR")
    make_label(&h201B, jp_label, 0, 0, "#SCRN")
    make_label(&h201E, jp_label, 0, 0, "#LOC")
    make_label(&h2021, jp_label, 0, 0, "#FLGET")
    make_label(&h2024, jp_label, 0, 0, "#RDVSW")
    make_label(&h2027, jp_label, 0, 0, "#SDVSW")
    make_label(&h202A, jp_label, 0, 0, "#INP")
    make_label(&h202D, jp_label, 0, 0, "#OUT")
    make_label(&h2030, jp_label, 0, 0, "#WIDCH")
    make_label(&h2033, jp_label, 0, 0, "#ERROR")

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
