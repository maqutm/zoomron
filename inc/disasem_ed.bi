FUNCTION disasem_ed(mem AS UBYTE PTR, st AS INTEGER) AS INTEGER
	
	DIM AS UBYTE c = mem[st]
	DIM AS INTEGER d = (c AND &hc0) / 64
	DIM AS INTEGER r0 = (c AND &h38) / 8
	DIM AS INTEGER r1 = (c AND &h7)
	DIM AS INTEGER h = (c AND &hf0) / 16
	DIM AS INTEGER l = c AND &hf
	
	IF c = &h70 THEN
		out_text "IN F,(C)"
	ELSEIF c = &h71 THEN
		out_text "OUT (C),0"
	ELSEIF d = 1 AND r1 = 0 THEN
		out_text "IN " + reg8(r0) + ",(C)"
	ELSEIF d = 1 AND r1 = 1 THEN
		out_text "OUT (C)," + reg8(r0)
	ELSEIF d = 1 AND l = 2 THEN
		out_text calc8(3) + " HL," + reg16(h AND 3)
	ELSEIF d = 1 AND l = 3 THEN
		out_text "LD (" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access) +")," + reg16(h AND 3)
		RETURN 4
	ELSEIF d = 1 AND l = 10 THEN
		out_text calc8(1) + " HL," + reg16(h AND 3)
	ELSEIF d = 1 AND l = 11 THEN
		out_text "LD " + reg16(h AND 3) +",(" + make_label(mem[st + 1] + mem[st + 2] * 256, direct_access) +")"
		RETURN 4
	ELSEIF d = 1 AND r1 = 4 THEN
		'&h44
		out_text "NEG"
	ELSEIF d = 1 AND (r0 AND 1) = 0 AND r1 = 5 THEN
		'&h45
		out_text "RETN"
	ELSEIF d = 1 AND (r0 AND 1) = 1 AND r1 = 5 THEN
		'&h4d
		out_text "RETI"
	ELSEIF d = 1 AND (r0 AND 2) = 0 AND r1 = 6 THEN
		'&h46
		out_text "IM 0"
	ELSEIF d = 1 AND (r0 AND 3) = 2 AND r1 = 6 THEN
		'&h56
		out_text "IM 1"
	ELSEIF d = 1 AND (r0 AND 3) = 3 AND r1 = 6 THEN
		'&h5e
		out_text "IM 2"
	ELSEIF d = 2 AND r0 = 4 AND r1 < 4 THEN
		out_text repti(r1)
	ELSEIF d = 2 AND r0 = 5 AND r1 < 4 THEN
		out_text reptd(r1)
	ELSEIF d = 2 AND r0 = 6 AND r1 < 4 THEN
		out_text reptir(r1)
	ELSEIF d = 2 AND r0 = 7 AND r1 < 4 THEN
		out_text reptdr(r1)
	ELSEIF c = &h47 THEN
		out_text "LD I,A"
	ELSEIF c = &h4f THEN
		out_text "LD R,A"
	ELSEIF c = &h57 THEN
		out_text "LD A,I"
	ELSEIF c = &h5f THEN
		out_text "LD A,R"
	ELSEIF c = &h67 THEN
		out_text "RRD"
	ELSEIF c = &h6f THEN
		out_text "RLD"
	ELSEIF c = &h7f THEN
		out_text "LD R,R"
'    Elseif d = 3 and r1 = 1 Then
'        out_text "MULUB A," + reg8(r0)
'    Elseif d = 3 and l = 3 Then
'        out_text "MULUW HL," + reg16(h and 3)
	ELSE
		out_text "DB 0EDh, " + make_numeric_constant(c)
	END IF
	
	RETURN 2
	
END FUNCTION