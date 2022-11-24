function disasem_ixy(mem as ubyte ptr, st as integer, ixy as integer) as integer
	
	dim as ubyte c = mem[st]
	dim as integer d = (c and &hc0) / 64
	dim as integer r0 = (c and &h38) / 8
	dim as integer r1 = (c and &h7)
	dim as integer h = (c and &hf0) / 16
	dim as integer l = c and &hf
	
	If d = 0 and l = 9 Then
		out_text "ADD " + ixreg(ixy) + "," + ixreg16a(h and 3, ixy)
	ElseIf d = 0 and (r0 = 4 or r0 = 5) and r1 = 4 Then
		out_text "INC " + ixreg8(r0, ixy)
	ElseIf d = 0 and (r0 = 6) and r1 = 4 Then
		out_text "INC (" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
		return 3
	ElseIf d = 0 and (r0 = 4 or r0 = 5) and r1 = 5 Then
		out_text "DEC " + ixreg8(r0, ixy)
	ElseIf d = 0 and (r0 = 6) and r1 = 5 Then
		out_text "DEC (" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
		return 3
	ElseIf d = 0 and (r0 = 4 or r0 = 5) and r1 = 6 Then
		out_text "LD " + ixreg8(r0, ixy) + "," + make_numeric_constant(mem[st + 2])
		return 3
	ElseIf d = 0 and (r0 = 6) and r1 = 6 Then
		out_text "LD (" + ixreg(ixy) + dsp(mem[st + 2]) + ")," + make_numeric_constant(mem[st + 3])
		return 3
	ElseIf d = 0 and (h = 2) and l = 1 Then
		out_text "LD " + ixreg(ixy) + "," + make_label(mem[st + 2] + mem[st + 3] * 256, immediate_data)
		return 4
	ElseIf d = 0 and (h = 2) and l = 2 Then
		out_text "LD (" + make_label(mem[st + 2] + mem[st + 3] * 256, direct_access) + ")," + ixreg(ixy)
		return 4
	ElseIf d = 0 and (h = 2) and l = 3 Then
		out_text "INC " + ixreg(ixy)
	ElseIf d = 0 and (h = 2) and l = 10 Then
		out_text "LD " + ixreg(ixy) + ",(" + make_label(mem[st + 2] + mem[st + 3] * 256, direct_access) + ")"
		return 4
	ElseIf d = 0 and (h = 2) and l = 11 Then
		out_text "DEC " + ixreg(ixy)
	ElseIf d = 1 and (r0 = 4 or r0 = 5) Then
		out_text "LD " + ixreg8(r0, ixy) + "," + ixreg8(r1, ixy)
	ElseIf d = 1 and (r0 = 6) and (r1 <> 6) Then
		out_text "LD (" + ixreg(ixy) + dsp(mem[st + 2]) + ")," + ixreg8(r1, ixy)
		return 3
	ElseIf d = 1 and (r1 = 4 or r1 = 5)Then
		out_text "LD " + ixreg8(r0, ixy) + "," + ixreg8(r1, ixy)
	ElseIf d = 1 and (r0 <> 6) and (r1 = 6) Then
		out_text "LD " + ixreg8(r0, ixy) + ",(" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
		return 3
	ElseIf d = 2 and ((r0 = 0) or (r0 = 1) or (r0 = 3)) and (r1 = 4 or r1 = 5)Then
		out_text calc8(r0) + " A," + ixreg8(r1, ixy)
	ElseIf d = 2 and (r1 = 4 or r1 = 5)Then
		out_text calc8(r0) + " " + ixreg8(r1, ixy)
	ElseIf d = 2 and ((r0 = 0) or (r0 = 1) or (r0 = 3)) and (r1 = 6) Then
		out_text calc8(r0) + " A," + ",(" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
		return 3
	ElseIf d = 2 and (r1 = 6) Then
		out_text calc8(r0) + " (" + ixreg(ixy) + dsp(mem[st + 2]) + ")"
		return 3
	Elseif c = &hCB Then
		'IX/IY CB
		return disasem_ixy_cb(mem, st + 1, ixy)
	Elseif c = &hE1 Then
		out_text "POP " + ixreg(ixy)
	Elseif c = &hE3 Then
		out_text "EX (SP)," + ixreg(ixy)
	Elseif c = &hE5 Then
		out_text "PUSH " + ixreg(ixy)
	Elseif c = &hE9 Then
		out_text "JP (" + ixreg(ixy) + ")"
	Elseif c = &hF9 Then
		out_text "LD SP," + ixreg(ixy)
	Else
		if ixy = 0 Then
			out_text "DB 0DDh, " + make_numeric_constant(c)
		Else
			out_text "DB 0FDh, " + make_numeric_constant(c)
		End If
	end If
	
	return 2
	
end function