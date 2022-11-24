function check_label(x as integer) as Boolean
	if adrs_wrk_cnt > 0 Then
		For i as integer = 0 to adrs_wrk_cnt -1
			if (adrs_wrk(i).st = x) Then
				Return True
			end if
		Next
	else
		Return False
	end if
end function

function search_label(x as integer) as adrs_wrk_t
	if adrs_wrk_cnt > 0 Then
		For i as integer = 0 to adrs_wrk_cnt -1
			if (adrs_wrk(i).st = x) Then
				Return adrs_wrk(i)
			end if
		Next
	end if
    Error 100
end function

function make_label(x as integer, t as adrs_type, sz as integer = -1 , dt as integer = -1) as string
	if not check_label(x) Then
		adrs_wrk(adrs_wrk_cnt).st = x
		adrs_wrk(adrs_wrk_cnt).sz = sz
		adrs_wrk(adrs_wrk_cnt).dt = dt
		adrs_wrk(adrs_wrk_cnt).t = t
		adrs_wrk_cnt = adrs_wrk_cnt + 1

        if (t = direct_access) Then
		    make_msg(x, 2, word_data)
		elseif (t = direct_access_8) Then
		    make_msg(x, 1, byte_data)
		end if
	End if
	if gen_pass <> 2 Then
		return hex4(x) + "h"
	else
		return "L" + hex4(x)
	end if
end function
