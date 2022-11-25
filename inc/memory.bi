FUNCTION hex4(x AS INTEGER) AS STRING
    RETURN RIGHT("000" + HEX(x), 4)
END FUNCTION

FUNCTION hex2(x AS INTEGER) AS STRING
    RETURN RIGHT("0" + HEX(x), 2)
END FUNCTION

FUNCTION dump4(mem AS UBYTE PTR, st AS INTEGER, l AS INTEGER) AS STRING
    IF l = 1 THEN
        RETURN hex2(mem[st]) + "         "
    ELSEIF l = 2 THEN
        RETURN hex2(mem[st]) + " " + hex2(mem[st + 1]) + "      "
    ELSEIF l = 3 THEN
        RETURN hex2(mem[st]) + " " + hex2(mem[st + 1]) + " " + hex2(mem[st + 2]) + "   "
    ELSEIF l = 4 THEN
        RETURN hex2(mem[st]) + " " + hex2(mem[st + 1]) + " " + hex2(mem[st + 2]) + " " + hex2(mem[st + 3])
    END IF
END FUNCTION

FUNCTION _min(a AS INTEGER, b AS INTEGER) AS INTEGER
    IF a > b THEN
        RETURN b
    ELSE
        RETURN a
    END IF
END FUNCTION

FUNCTION dump8(mem AS UBYTE PTR, st AS INTEGER, l AS INTEGER) AS STRING
    DIM AS STRING text
    FOR i AS INTEGER = 0 TO _min(7, l)
        text = text + hex2(mem[st + i]) + " "
    NEXT
    text = text + SPACE( 3 * (7 - l) )

    RETURN text
END FUNCTION

FUNCTION search_ubyte(mem AS UBYTE PTR, st AS INTEGER, dt AS INTEGER) AS INTEGER
    DIM AS UBYTE c 
    DO 
        c = mem[st]
        ' Print #2, hex2(c);
        IF c = dt THEN
            ' Print #2, ""
            RETURN st
        END IF
        st = st + 1
    LOOP
END FUNCTION

FUNCTION is_display(c AS UBYTE) AS BOOLEAN
    RETURN (c > &h1f AND c < &h7f)
END FUNCTION

FUNCTION make_message(mem AS UBYTE PTR, st AS INTEGER, sz AS INTEGER) AS STRING

    DIM AS STRING msg_out = ""
    DIM AS BOOLEAN in_str = FALSE

    FOR i AS INTEGER = 0  TO sz
        IF i <> 0 AND NOT in_str THEN 
            msg_out = msg_out + ", "
        END IF
        DIM AS UBYTE c = mem[st + i]
        IF is_display(c) THEN
            IF in_str THEN
                msg_out = msg_out + CHR(c)
            ELSE 
                msg_out = msg_out + "'" + CHR(c)
            END IF
            in_str = TRUE
        ELSE 
            IF in_str THEN
                msg_out = msg_out + "', " + make_numeric_constant(c)
            ELSE 
                msg_out = msg_out + make_numeric_constant(c)
            END IF
            in_str = FALSE
        END IF
    NEXT 
    IF in_str THEN
        msg_out = msg_out + "'"
    END IF 
    RETURN msg_out

END FUNCTION
