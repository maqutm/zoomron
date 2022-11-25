FUNCTION disasem_ixy_cb(mem AS UBYTE PTR, st AS INTEGER, ixy AS INTEGER) AS INTEGER
	
	DIM AS UBYTE c = mem[st]
	DIM AS INTEGER d = (c AND &hc0) / 64
	DIM AS INTEGER r0 = (c AND &h38) / 8
	DIM AS INTEGER r1 = (c AND &h7)
	
	IF d = 0 AND (r1 = 6) THEN
		out_text rot1(r0) + " (" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
	ELSEIF d = 0 AND (r1 <> 6) THEN
		out_text rot1(r0) + " (" + ixreg(ixy) + dsp(mem[st + 2]) + ") :" + reg8(r1)
	ELSEIF (d <> 0) AND (r1 = 6) THEN
		out_text bit0(d-1) + " " + STR(r0) + ",(" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
	ELSEIF (d <> 0) AND (r1 <> 6) THEN
		out_text bit0(d-1) + " " + STR(r0) + ",(" + ixreg(ixy) + dsp(mem[st + 2]) + ") :" + reg8(r1)
	END IF
	
	RETURN 4
	
END FUNCTION
