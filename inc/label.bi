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

FUNCTION make_label(x AS INTEGER, t AS adrs_type, sz AS INTEGER = -1 , dt AS INTEGER = -1) AS STRING
	IF search_label(x) = -1 THEN
		adrs_wrk(adrs_wrk_cnt).st = x
		adrs_wrk(adrs_wrk_cnt).sz = sz
		adrs_wrk(adrs_wrk_cnt).dt = dt
		adrs_wrk(adrs_wrk_cnt).t = t
		adrs_wrk_cnt = adrs_wrk_cnt + 1

        IF (t = direct_access) THEN
		    make_msg(x, 2, word_data)
		ELSEIF (t = direct_access_8) THEN
		    make_msg(x, 1, byte_data)
		END IF
	END IF
	IF gen_pass <> 2 THEN
		RETURN hex4(x) + "h"
	ELSE
		RETURN "L" + hex4(x)
	END IF
END FUNCTION
