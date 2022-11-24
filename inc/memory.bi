function hex4(x as integer) as string
    return right("000" + hex(x), 4)
end function

function hex2(x as integer) as string
    return right("0" + hex(x), 2)
end function

function dump4(mem as ubyte ptr, st as integer, l as integer) as string
    If l = 1 Then
        return hex2(mem[st]) + "         "
    ElseIf l = 2 Then
        return hex2(mem[st]) + " " + hex2(mem[st + 1]) + "      "
    ElseIf l = 3 Then
        return hex2(mem[st]) + " " + hex2(mem[st + 1]) + " " + hex2(mem[st + 2]) + "   "
    ElseIf l = 4 Then
        return hex2(mem[st]) + " " + hex2(mem[st + 1]) + " " + hex2(mem[st + 2]) + " " + hex2(mem[st + 3])
    End If
end function

function _min(a as integer, b as integer) as integer
    if a > b Then
        Return b
    else
        Return a
    End If
end function

function dump8(mem as ubyte ptr, st as integer, l as integer) as string
    dim as string text
    For i as integer = 0 to _min(7, l)
        text = text + hex2(mem[st + i]) + " "
    Next
    text = text + space( 3 * (7 - l) )

    Return text
end function

function search_ubyte(mem as ubyte ptr, st as integer, dt as integer) as Integer
    dim as ubyte c 
    Do 
        c = mem[st]
        ' Print #2, hex2(c);
        if c = dt Then
            ' Print #2, ""
            return st
        end if
        st = st + 1
    loop
end function

function is_display(c as ubyte) as boolean
    return (c > &h1f and c < &h7f)
end function

function make_message(mem as ubyte ptr, st as integer, sz as integer) as string

    dim as string msg_out = ""
    dim as boolean in_str = false

    for i as integer = 0  to sz
        if i <> 0 and not in_str Then 
            msg_out = msg_out + ", "
        end if
        dim as ubyte c = mem[st + i]
        if is_display(c) Then
            if in_str Then
                msg_out = msg_out + Chr(c)
            else 
                msg_out = msg_out + "'" + Chr(c)
            end if
            in_str = true
        else 
            if in_str Then
                msg_out = msg_out + "', " + make_numeric_constant(c)
            else 
                msg_out = msg_out + make_numeric_constant(c)
            end if
            in_str = false
        end if
    next 
    if in_str Then
        msg_out = msg_out + "'"
    end if 
    return msg_out

end function
