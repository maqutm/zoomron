FUNCTION disasem_cb(mem AS UBYTE PTR, st AS INTEGER) AS INTEGER
	
	DIM AS UBYTE c = mem[st]
	DIM AS INTEGER d = (c AND &hc0) / 64
	DIM AS INTEGER r0 = (c AND &h38) / 8
	DIM AS INTEGER r1 = (c AND &h7)
	
	IF d = 0 THEN
		out_text rot1(r0) + " " + reg8(r1)
	ELSE
		out_text bit0(d-1) + " " + STR(r0) + "," + reg8(r1)
	END IF
	
	RETURN 2
	
END FUNCTION