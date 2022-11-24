function check_msg(x as integer) as Boolean
	if msg_wrk_cnt > 0 Then
		For j as integer = 0 to msg_wrk_cnt -1
			if (msg_wrk(j).st = x) Then
				Return True
			end if
		Next
	else
		Return False
	end if
end function

function search_msg(x as integer) as msg_wrk_t
	if msg_wrk_cnt > 0 Then
		For j as integer = 0 to msg_wrk_cnt -1
			if (msg_wrk(j).st = x) Then
				Return msg_wrk(j)
			end if
		Next
	end if
    Error 100
end function

function make_msg(x as integer, sz as integer, t as msg_type) as string
	if not check_msg(x) Then
		msg_wrk(msg_wrk_cnt).st = x
		msg_wrk(msg_wrk_cnt).ed = x + sz - 1
		msg_wrk(msg_wrk_cnt).t = t
		msg_wrk_cnt = msg_wrk_cnt + 1
	End if
	if gen_pass <> 2 Then
		return hex4(x) + "h"
	else
		return "L" + hex4(x)
	end if
end function
