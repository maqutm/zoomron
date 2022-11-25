FUNCTION disasem(mem AS UBYTE PTR, st AS INTEGER) AS INTEGER
	
	DIM AS UBYTE c = mem[st]
	DIM AS INTEGER d = (c AND &hc0) / 64
	DIM AS INTEGER r0 = (c AND &h38) / 8
	DIM AS INTEGER r1 = (c AND &h7)
	DIM AS INTEGER h = (c AND &hf0) / 16
	DIM AS INTEGER l = c AND &hf
	DIM AS INTEGER adrs
	
	IF d = 0 AND r0 = 0 AND r1 = 0 THEN
		out_text "NOP"
	ELSEIF d = 0 AND r0 = 1 AND r1 = 0 THEN
		out_text "EX AF,AF'"
	ELSEIF d = 0 AND r0 = 2 AND r1 = 0 THEN
		out_text "DJNZ " + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		RETURN 2
	ELSEIF d = 0 AND r0 = 3 AND r1 = 0 THEN
		out_text "JR " + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		RETURN 2
	ELSEIF d = 0 AND r0 = 4 AND r1 = 0 THEN
		out_text "JR NZ," + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		RETURN 2
	ELSEIF d = 0 AND r0 = 5 AND r1 = 0 THEN
		out_text "JR Z," + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		RETURN 2
	ELSEIF d = 0 AND r0 = 6 AND r1 = 0 THEN
		out_text "JR NC," + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		RETURN 2
	ELSEIF d = 0 AND r0 = 7 AND r1 = 0 THEN
		out_text "JR C," + make_label(relativ(st + 2, mem[st + 1]), jp_label)
		RETURN 2
	ELSEIF d = 0 AND (r0 AND 1) = 0 AND r1 = 1 THEN
		out_text "LD " + reg16(h) + "," + make_label(mem[st + 1] + mem[st + 2] * 256, immediate_data)
		RETURN 3
	ELSEIF d = 0 AND r1 = 1 THEN
		out_text "ADD HL," + reg16(h)
	ELSEIF d = 0 AND r0 = 0 AND r1 = 2 THEN
		out_text "LD (BC),A"
	ELSEIF d = 0 AND r0 = 1 AND r1 = 2 THEN
		out_text "LD A,(BC)"
	ELSEIF d = 0 AND r0 = 2 AND r1 = 2 THEN
		out_text "LD (DE),A"
	ELSEIF d = 0 AND r0 = 3 AND r1 = 2 THEN
		out_text "LD A,(DE)"
	ELSEIF d = 0 AND r0 = 4 AND r1 = 2 THEN
		out_text "LD (" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access) +"),HL"
		RETURN 3
	ELSEIF d = 0 AND r0 = 5 AND r1 = 2 THEN
		out_text "LD HL,(" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access) +")"
		RETURN 3
	ELSEIF d = 0 AND r0 = 6 AND r1 = 2 THEN
		out_text "LD (" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access_8) +"),A"
		RETURN 3
	ELSEIF d = 0 AND r0 = 7 AND r1 = 2 THEN
		out_text "LD A,(" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access_8) +")"
		RETURN 3
	ELSEIF d = 0 AND (r0 AND 1) = 0 AND r1 = 3 THEN
		out_text "INC " + reg16(h)
	ELSEIF d = 0 AND r1 = 3 THEN
		out_text "DEC " + reg16(h)
	ELSEIF d = 0 AND r1 = 4 THEN
		out_text "INC "  + reg8(r0)
	ELSEIF d = 0 AND r1 = 5 THEN
		out_text "DEC "  + reg8(r0)
	ELSEIF d = 0 AND r1 = 6 THEN
		out_text "LD "  + reg8(r0) + "," + make_numeric_constant(mem[st + 1])
		RETURN 2
	ELSEIF d = 0 AND r1 = 7 THEN
		out_text rot0(r0)
	ELSEIF d = 1 AND ((r0 <> 6) OR (r1 <> 6)) THEN
		out_text "LD "+ reg8(r0) + "," + reg8(r1)
	ELSEIF d = 1 AND r0 = 6 AND r1 = 6 THEN
		out_text "HALT"
	ELSEIF d = 2 AND ((r0 = 0) OR (r0 = 1) OR (r0 = 3)) THEN
		out_text calc8(r0) + " A," + reg8(r1)
	ELSEIF d = 2 THEN
		out_text calc8(r0) + " " + reg8(r1)
	ELSEIF d = 3 AND r1 = 0 THEN
		out_text "RET " + cond(r0)
	ELSEIF d = 3 AND ((r0 = 0) OR (r0 = 2) OR (r0 = 4) OR (r0 = 6)) AND r1 = 1Then
		out_text "POP " + reg16a(h AND 3)
	ELSEIF d = 3 AND r0 = 1 AND r1 = 1 THEN
		out_text "RET"
	ELSEIF d = 3 AND r0 = 3 AND r1 = 1 THEN
		out_text "EXX"
	ELSEIF d = 3 AND r0 = 5 AND r1 = 1 THEN
		out_text "JP (HL)"
	ELSEIF d = 3 AND r0 = 7 AND r1 = 1 THEN
		out_text "LD SP,HL"
	ELSEIF d = 3 AND r1 = 2 THEN
		out_text "JP " + cond(r0) + "," + make_label(mem[st + 1] + mem[st + 2] * 256, jp_label)
		RETURN 3
	ELSEIF d = 3 AND r0 = 0 AND r1 = 3 THEN
		out_text "JP " + make_label(mem[st + 1] + mem[st + 2] * 256, jp_label)
		RETURN 3
	ELSEIF d = 3 AND r0 = 1 AND r1 = 3 THEN
		' CB xx
		RETURN disasem_cb(mem, st + 1)
	ELSEIF d = 3 AND r0 = 2 AND r1 = 3 THEN
		out_text "OUT (" + make_numeric_constant(mem[st + 1]) + "),A"
		RETURN 2
	ELSEIF d = 3 AND r0 = 3 AND r1 = 3 THEN
		out_text "IN A,(" + make_numeric_constant(mem[st + 1]) + ")"
		RETURN 2
	ELSEIF d = 3 AND r0 = 4 AND r1 = 3 THEN
		out_text "EX (SP),HL"
	ELSEIF d = 3 AND r0 = 5 AND r1 = 3 THEN
		out_text "EX DE,HL"
	ELSEIF d = 3 AND r0 = 6 AND r1 = 3 THEN
		out_text "DI"
	ELSEIF d = 3 AND r0 = 7 AND r1 = 3 THEN
		out_text "EI"
	ELSEIF d = 3 AND r1 = 4 THEN
	    adrs = mem[st + 1] + mem[st + 2] * 256
		out_text "CALL " + cond(r0) + "," + make_label(adrs, call_label)
		after_call_ope = TRUE
		last_call_adrs = adrs
		RETURN 3
	ELSEIF d = 3 AND ((r0 = 0) OR (r0 = 2) OR (r0 = 4) OR (r0 = 6)) AND r1 = 5 THEN
		out_text "PUSH " + reg16a(h AND 3)
	ELSEIF d = 3 AND r0 = 1 AND r1 = 5 THEN
    	adrs = mem[st + 1] + mem[st + 2] * 256
		out_text "CALL " + make_label(adrs, call_label)
		after_call_ope = TRUE
		last_call_adrs = adrs
		RETURN 3
	ELSEIF d = 3 AND r0 = 3 AND r1 = 5 THEN
		'IX
		RETURN disasem_ixy(mem, st + 1, 0)
	ELSEIF d = 3 AND r0 = 5 AND r1 = 5 THEN
		'ED xx
		RETURN disasem_ed(mem, st + 1)
	ELSEIF d = 3 AND r0 = 7 AND r1 = 5 THEN
		'IY
		RETURN disasem_ixy(mem, st + 1, 1)
	ELSEIF d = 3 AND ((r0 = 0) OR (r0 = 1) OR (r0 = 3)) AND r1 = 6 THEN
		out_text calc8(r0) + " A," + make_numeric_constant(mem[st + 1])
		RETURN 2
	ELSEIF d = 3 AND r1 = 6 THEN
		out_text calc8(r0) + " " + make_numeric_constant(mem[st + 1])
		RETURN 2
	ELSEIF d = 3 AND r1 = 7 THEN
		out_text "RST " + make_numeric_constant(r0 * 8)
	END IF
	
	RETURN 1
	
END FUNCTION
