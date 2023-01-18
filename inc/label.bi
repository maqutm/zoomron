FUNCTION search_label(x AS INTEGER) AS INTEGER
	IF adrs_wrk_cnt > 0 THEN
		FOR i AS INTEGER = 0 TO adrs_wrk_cnt -1
			IF (adrs_wrk(i).st = x) THEN
				RETURN i
			END IF
		NEXT
	END IF
    RETURN -1
END FUNCTION

FUNCTION make_label(x AS INTEGER, t AS adrs_type, sz AS INTEGER = 0 , dt AS INTEGER = 0, n AS STRING = "") AS STRING
    DIM AS INTEGER lbl = search_label(x)
	IF lbl = -1 THEN
	    lbl = adrs_wrk_cnt
		adrs_wrk_cnt = adrs_wrk_cnt + 1

		adrs_wrk(lbl).st = x
		adrs_wrk(lbl).sz = sz
		adrs_wrk(lbl).dt = dt
		adrs_wrk(lbl).t = t
		if n = "" THEN
			adrs_wrk(lbl).n = "L" + hex4(x)
		ELSE 
			adrs_wrk(lbl).n = n
		END IF

        IF (t = direct_access) THEN
		    make_msg(x, 2, word_data)
		ELSEIF (t = direct_access_8) THEN
		    make_msg(x, 1, byte_data)
		END IF
	END IF
	IF gen_pass <> 2 THEN
		RETURN hex4(x) + "h"
	ELSE
		RETURN adrs_wrk(lbl).n
	END IF
END FUNCTION
