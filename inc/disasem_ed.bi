function disasem_ed(mem as ubyte ptr, st as integer) as integer
	
	dim as ubyte c = mem[st]
	dim as integer d = (c and &hc0) / 64
	dim as integer r0 = (c and &h38) / 8
	dim as integer r1 = (c and &h7)
	dim as integer h = (c and &hf0) / 16
	dim as integer l = c and &hf
	
	If c = &h70 Then
		out_text "IN F,(C)"
	ElseIf c = &h71 Then
		out_text "OUT (C),0"
	Elseif d = 1 and r1 = 0 Then
		out_text "IN " + reg8(r0) + ",(C)"
	Elseif d = 1 and r1 = 1 Then
		out_text "OUT (C)," + reg8(r0)
	Elseif d = 1 and l = 2 Then
		out_text calc8(3) + " HL," + reg16(h and 3)
	Elseif d = 1 and l = 3 Then
		out_text "LD (" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access) +")," + reg16(h and 3)
		return 4
	Elseif d = 1 and l = 10 Then
		out_text calc8(1) + " HL," + reg16(h and 3)
	Elseif d = 1 and l = 11 Then
		out_text "LD " + reg16(h and 3) +",(" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access) +")"
		return 4
	Elseif d = 1 and r1 = 4 Then
		'&h44
		out_text "NEG"
	Elseif d = 1 and (r0 and 1) = 0 and r1 = 5 Then
		'&h45
		out_text "RETN"
	Elseif d = 1 and (r0 and 1) = 1 and r1 = 5 Then
		'&h4d
		out_text "RETI"
	Elseif d = 1 and (r0 and 2) = 0 and r1 = 6 Then
		'&h46
		out_text "IM 0"
	Elseif d = 1 and (r0 and 3) = 2 and r1 = 6 Then
		'&h56
		out_text "IM 1"
	Elseif d = 1 and (r0 and 3) = 3 and r1 = 6 Then
		'&h5e
		out_text "IM 2"
	Elseif d = 2 and r0 = 4 and r1 < 4 Then
		out_text repti(r1)
	Elseif d = 2 and r0 = 5 and r1 < 4 Then
		out_text reptd(r1)
	Elseif d = 2 and r0 = 6 and r1 < 4 Then
		out_text reptir(r1)
	Elseif d = 2 and r0 = 7 and r1 < 4 Then
		out_text reptdr(r1)
	Elseif c = &h47 Then
		out_text "LD I,A"
	Elseif c = &h4f Then
		out_text "LD R,A"
	Elseif c = &h57 Then
		out_text "LD A,I"
	Elseif c = &h5f Then
		out_text "LD A,R"
	Elseif c = &h67 Then
		out_text "RRD"
	Elseif c = &h6f Then
		out_text "RLD"
	Elseif c = &h7f Then
		out_text "LD R,R"
'    Elseif d = 3 and r1 = 1 Then
'        out_text "MULUB A," + reg8(r0)
'    Elseif d = 3 and l = 3 Then
'        out_text "MULUW HL," + reg16(h and 3)
	Else
		out_text "DB 0EDh, " + make_numeric_constant(c)
	End If
	
	return 2
	
end function