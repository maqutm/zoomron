FUNCTION check_msg(x AS INTEGER) AS BOOLEAN
	IF msg_wrk_cnt > 0 THEN
		FOR j AS INTEGER = 0 TO msg_wrk_cnt -1
			IF (msg_wrk(j).st = x) THEN
				RETURN TRUE
			END IF
		NEXT
	ELSE
		RETURN FALSE
	END IF
END FUNCTION

FUNCTION search_msg(x AS INTEGER) AS msg_wrk_t
	IF msg_wrk_cnt > 0 THEN
		FOR j AS INTEGER = 0 TO msg_wrk_cnt -1
			IF (msg_wrk(j).st = x) THEN
				RETURN msg_wrk(j)
			END IF
		NEXT
	END IF
    ERROR 100
END FUNCTION

FUNCTION make_msg(x AS INTEGER, sz AS INTEGER, t AS msg_type) AS STRING
	IF NOT check_msg(x) THEN
		msg_wrk(msg_wrk_cnt).st = x
		msg_wrk(msg_wrk_cnt).ed = x + sz - 1
		msg_wrk(msg_wrk_cnt).t = t
		msg_wrk_cnt = msg_wrk_cnt + 1
	END IF
	IF gen_pass <> 2 THEN
		RETURN hex4(x) + "h"
	ELSE
		RETURN "L" + hex4(x)
	END IF
END FUNCTION
