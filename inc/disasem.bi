function disasem(mem as ubyte ptr, st as integer) as integer
	
	dim as ubyte c = mem[st]
	dim as integer d = (c and &hc0) / 64
	dim as integer r0 = (c and &h38) / 8
	dim as integer r1 = (c and &h7)
	dim as integer h = (c and &hf0) / 16
	dim as integer l = c and &hf
	dim as integer adrs
	
	If d = 0 and r0 = 0 and r1 = 0 Then
		out_text "NOP"
	Elseif d = 0 and r0 = 1 and r1 = 0 Then
		out_text "EX AF,AF'"
	Elseif d = 0 and r0 = 2 and r1 = 0 Then
		out_text "DJNZ " + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		return 2
	Elseif d = 0 and r0 = 3 and r1 = 0 Then
		out_text "JR " + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		return 2
	Elseif d = 0 and r0 = 4 and r1 = 0 Then
		out_text "JR NZ," + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		return 2
	Elseif d = 0 and r0 = 5 and r1 = 0 Then
		out_text "JR Z," + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		return 2
	Elseif d = 0 and r0 = 6 and r1 = 0 Then
		out_text "JR NC," + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		return 2
	Elseif d = 0 and r0 = 7 and r1 = 0 Then
		out_text "JR C," + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		return 2
	Elseif d = 0 and (r0 and 1) = 0 and r1 = 1 Then
		out_text "LD " + reg16(h) + "," + make_label(mem[st + 1] + mem[st + 2] * 256, immediate_data)
		return 3
	Elseif d = 0 and r1 = 1 Then
		out_text "ADD HL," + reg16(h)
	Elseif d = 0 and r0 = 0 and r1 = 2 Then
		out_text "LD (BC),A"
	Elseif d = 0 and r0 = 1 and r1 = 2 Then
		out_text "LD A,(BC)"
	Elseif d = 0 and r0 = 2 and r1 = 2 Then
		out_text "LD (DE),A"
	Elseif d = 0 and r0 = 3 and r1 = 2 Then
		out_text "LD A,(DE)"
	Elseif d = 0 and r0 = 4 and r1 = 2 Then
		out_text "LD (" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access) +"),HL"
		return 3
	Elseif d = 0 and r0 = 5 and r1 = 2 Then
		out_text "LD HL,(" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access) +")"
		return 3
	Elseif d = 0 and r0 = 6 and r1 = 2 Then
		out_text "LD (" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access_8) +"),A"
		return 3
	Elseif d = 0 and r0 = 7 and r1 = 2 Then
		out_text "LD A,(" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access_8) +")"
		return 3
	Elseif d = 0 and (r0 and 1) = 0 and r1 = 3 Then
		out_text "INC " + reg16(h)
	Elseif d = 0 and r1 = 3 Then
		out_text "DEC " + reg16(h)
	Elseif d = 0 and r1 = 4 Then
		out_text "INC "  + reg8(r0)
	Elseif d = 0 and r1 = 5 Then
		out_text "DEC "  + reg8(r0)
	Elseif d = 0 and r1 = 6 Then
		out_text "LD "  + reg8(r0) + "," + make_numeric_constant(mem[st + 1])
		return 2
	Elseif d = 0 and r1 = 7 Then
		out_text rot0(r0)
	Elseif d = 1 and ((r0 <> 6) or (r1 <> 6)) Then
		out_text "LD "+ reg8(r0) + "," + reg8(r1)
	Elseif d = 1 and r0 = 6 and r1 = 6 Then
		out_text "HALT"
	Elseif d = 2 and ((r0 = 0) or (r0 = 1) or (r0 = 3)) Then
		out_text calc8(r0) + " A," + reg8(r1)
	Elseif d = 2 Then
		out_text calc8(r0) + " " + reg8(r1)
	Elseif d = 3 and r1 = 0 Then
		out_text "RET " + cond(r0)
	Elseif d = 3 and ((r0 = 0) or (r0 = 2) or (r0 = 4) or (r0 = 6)) and r1 = 1Then
		out_text "POP " + reg16a(h and 3)
	Elseif d = 3 and r0 = 1 and r1 = 1 Then
		out_text "RET"
	Elseif d = 3 and r0 = 3 and r1 = 1 Then
		out_text "EXX"
	Elseif d = 3 and r0 = 5 and r1 = 1 Then
		out_text "JP (HL)"
	Elseif d = 3 and r0 = 7 and r1 = 1 Then
		out_text "LD SP,HL"
	Elseif d = 3 and r1 = 2 Then
		out_text "JP " + cond(r0) + "," + make_label(mem[st + 1] + mem[st + 2] * 256, jp_label)
		return 3
	Elseif d = 3 and r0 = 0 and r1 = 3 Then
		out_text "JP " + make_label(mem[st + 1] + mem[st + 2] * 256, jp_label)
		return 3
	Elseif d = 3 and r0 = 1 and r1 = 3 Then
		' CB xx
		return disasem_cb(mem, st + 1)
	Elseif d = 3 and r0 = 2 and r1 = 3 Then
		out_text "OUT (" + make_numeric_constant(mem[st + 1]) + "),A"
		return 2
	Elseif d = 3 and r0 = 3 and r1 = 3 Then
		out_text "IN A,(" + make_numeric_constant(mem[st + 1]) + ")"
		return 2
	Elseif d = 3 and r0 = 4 and r1 = 3 Then
		out_text "EX (SP),HL"
	Elseif d = 3 and r0 = 5 and r1 = 3 Then
		out_text "EX DE,HL"
	Elseif d = 3 and r0 = 6 and r1 = 3 Then
		out_text "DI"
	Elseif d = 3 and r0 = 7 and r1 = 3 Then
		out_text "EI"
	Elseif d = 3 and r1 = 4 Then
	    adrs = mem[st + 1] + mem[st + 2] * 256
		out_text "CALL " + cond(r0) + "," + make_label(adrs, call_label)
		after_call_ope = True
		last_call_adrs = adrs
		return 3
	Elseif d = 3 and ((r0 = 0) or (r0 = 2) or (r0 = 4) or (r0 = 6)) and r1 = 5 Then
		out_text "PUSH " + reg16a(h and 3)
	Elseif d = 3 and r0 = 1 and r1 = 5 Then
    	adrs = mem[st + 1] + mem[st + 2] * 256
		out_text "CALL " + make_label(adrs, call_label)
		after_call_ope = True
		last_call_adrs = adrs
		return 3
	Elseif d = 3 and r0 = 3 and r1 = 5 Then
		'IX
		return disasem_ixy(mem, st + 1, 0)
	Elseif d = 3 and r0 = 5 and r1 = 5 Then
		'ED xx
		return disasem_ed(mem, st + 1)
	Elseif d = 3 and r0 = 7 and r1 = 5 Then
		'IY
		return disasem_ixy(mem, st + 1, 1)
	Elseif d = 3 and ((r0 = 0) or (r0 = 1) or (r0 = 3)) and r1 = 6 Then
		out_text calc8(r0) + " A," + make_numeric_constant(mem[st + 1])
		return 2
	Elseif d = 3 and r1 = 6 Then
		out_text calc8(r0) + " " + make_numeric_constant(mem[st + 1])
		return 2
	Elseif d = 3 and r1 = 7 Then
		out_text "RST " + make_numeric_constant(r0 * 8)
	End If
	
	return 1
	
end function
