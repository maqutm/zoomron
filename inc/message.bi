FUNCTION search_msg(x AS INTEGER) AS INTEGER
	IF msg_wrk_cnt > 0 THEN
		FOR j AS INTEGER = 0 TO msg_wrk_cnt -1
			IF (msg_wrk(j).st = x) THEN
				RETURN j
			END IF
		NEXT
	END IF
    RETURN -1
END FUNCTION

SUB make_msg(x AS INTEGER, sz AS INTEGER, t AS msg_type)
	IF search_msg(x) = -1 THEN
		msg_wrk(msg_wrk_cnt).st = x
		msg_wrk(msg_wrk_cnt).ed = x + sz - 1
		msg_wrk(msg_wrk_cnt).t = t
		msg_wrk_cnt = msg_wrk_cnt + 1
	END IF
END SUB
