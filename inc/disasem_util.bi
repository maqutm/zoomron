FUNCTION relativ(st AS INTEGER, e AS UBYTE) AS INTEGER
	IF e > 127 THEN
		RETURN st + adrs_offset + e - 256
	ELSE
		RETURN st + adrs_offset + e
	END IF
END FUNCTION

FUNCTION dsp(e AS UBYTE) AS STRING
	IF e > 127 THEN
		RETURN "" + STR(e - 256)
	ELSE
		RETURN "+" + STR(e)
	END IF
END FUNCTION

FUNCTION ixreg16a(r16 AS INTEGER, ixy AS INTEGER) AS STRING
	IF r16 = 2 THEN
		RETURN ixreg(ixy)
	ELSE
		RETURN reg16a(r16)
	END IF
END FUNCTION

FUNCTION ixreg8(r8 AS INTEGER, ixy AS INTEGER) AS STRING
	' r8 = 6の時はこれで処理しない
	
	IF r8 = 4 OR r8 = 5 THEN
		RETURN ixreg(ixy) + reg8(r8)
	ELSE
		RETURN reg8(r8)
	END IF
END FUNCTION

FUNCTION make_numeric_constant(x AS INTEGER) AS STRING
	IF (x < 10) THEN
		RETURN STR(x)
	ELSEIF (x > 9 AND x < 16) OR (x > &h9f) THEN
		RETURN "0" + HEX(x) + "h"
	ELSE
		RETURN HEX(x) + "h"
	END IF
END FUNCTION

SUB out_text(s AS STRING)
	output_line = s
END SUB