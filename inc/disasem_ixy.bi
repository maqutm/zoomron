FUNCTION disasem_ixy(mem AS UBYTE PTR, st AS INTEGER, ixy AS INTEGER) AS INTEGER
	
	DIM AS UBYTE c = mem[st]
	DIM AS INTEGER d = (c AND &hc0) / 64
	DIM AS INTEGER r0 = (c AND &h38) / 8
	DIM AS INTEGER r1 = (c AND &h7)
	DIM AS INTEGER h = (c AND &hf0) / 16
	DIM AS INTEGER l = c AND &hf
	
	IF d = 0 AND l = 9 THEN
		out_text "ADD " + ixreg(ixy) + "," + ixreg16a(h AND 3, ixy)
	ELSEIF d = 0 AND (r0 = 4 OR r0 = 5) AND r1 = 4 THEN
		out_text "INC " + ixreg8(r0, ixy)
	ELSEIF d = 0 AND (r0 = 6) AND r1 = 4 THEN
		out_text "INC (" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
		RETURN 3
	ELSEIF d = 0 AND (r0 = 4 OR r0 = 5) AND r1 = 5 THEN
		out_text "DEC " + ixreg8(r0, ixy)
	ELSEIF d = 0 AND (r0 = 6) AND r1 = 5 THEN
		out_text "DEC (" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
		RETURN 3
	ELSEIF d = 0 AND (r0 = 4 OR r0 = 5) AND r1 = 6 THEN
		out_text "LD " + ixreg8(r0, ixy) + "," + make_numeric_constant(mem[st + 2])
		RETURN 3
	ELSEIF d = 0 AND (r0 = 6) AND r1 = 6 THEN
		out_text "LD (" + ixreg(ixy) + dsp(mem[st + 2]) + ")," + make_numeric_constant(mem[st + 3])
		RETURN 3
	ELSEIF d = 0 AND (h = 2) AND l = 1 THEN
		out_text "LD " + ixreg(ixy) + "," + make_label(mem[st + 2] + mem[st + 3] * 256, immediate_data)
		RETURN 4
	ELSEIF d = 0 AND (h = 2) AND l = 2 THEN
		out_text "LD (" + make_label(mem[st + 2] + mem[st + 3] * 256, direct_access) + ")," + ixreg(ixy)
		RETURN 4
	ELSEIF d = 0 AND (h = 2) AND l = 3 THEN
		out_text "INC " + ixreg(ixy)
	ELSEIF d = 0 AND (h = 2) AND l = 10 THEN
		out_text "LD " + ixreg(ixy) + ",(" + make_label(mem[st + 2] + mem[st + 3] * 256, direct_access) + ")"
		RETURN 4
	ELSEIF d = 0 AND (h = 2) AND l = 11 THEN
		out_text "DEC " + ixreg(ixy)
	ELSEIF d = 1 AND (r0 = 4 OR r0 = 5) THEN
		out_text "LD " + ixreg8(r0, ixy) + "," + ixreg8(r1, ixy)
	ELSEIF d = 1 AND (r0 = 6) AND (r1 <> 6) THEN
		out_text "LD (" + ixreg(ixy) + dsp(mem[st + 2]) + ")," + ixreg8(r1, ixy)
		RETURN 3
	ELSEIF d = 1 AND (r1 = 4 OR r1 = 5)THEN
		out_text "LD " + ixreg8(r0, ixy) + "," + ixreg8(r1, ixy)
	ELSEIF d = 1 AND (r0 <> 6) AND (r1 = 6) THEN
		out_text "LD " + ixreg8(r0, ixy) + ",(" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
		RETURN 3
	ELSEIF d = 2 AND ((r0 = 0) OR (r0 = 1) OR (r0 = 3)) AND (r1 = 4 OR r1 = 5)THEN
		out_text calc8(r0) + " A," + ixreg8(r1, ixy)
	ELSEIF d = 2 AND (r1 = 4 OR r1 = 5)THEN
		out_text calc8(r0) + " " + ixreg8(r1, ixy)
	ELSEIF d = 2 AND ((r0 = 0) OR (r0 = 1) OR (r0 = 3)) AND (r1 = 6) THEN
		out_text calc8(r0) + " A," + ",(" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
		RETURN 3
	ELSEIF d = 2 AND (r1 = 6) THEN
		out_text calc8(r0) + " (" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
		RETURN 3
	ELSEIF c = &hCB THEN
		'IX/IY CB
		RETURN disasem_ixy_cb(mem, st + 1, ixy)
	ELSEIF c = &hE1 THEN
		out_text "POP " + ixreg(ixy)
	ELSEIF c = &hE3 THEN
		out_text "EX (SP)," + ixreg(ixy)
	ELSEIF c = &hE5 THEN
		out_text "PUSH " + ixreg(ixy)
	ELSEIF c = &hE9 THEN
		out_text "JP (" + ixreg(ixy) + ")"
	ELSEIF c = &hF9 THEN
		out_text "LD SP," + ixreg(ixy)
	ELSE
		IF ixy = 0 THEN
			out_text "DB 0DDh, " + make_numeric_constant(c)
		ELSE
			out_text "DB 0FDh, " + make_numeric_constant(c)
		END IF
	END IF
	
	RETURN 2
	
END FUNCTION