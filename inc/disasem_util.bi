function relativ(st as integer, e as ubyte) as integer
	if e > 127 Then
		return st + adrs_offset + e - 256
	Else
		return st + adrs_offset + e
	End if
end function

function dsp(e as ubyte) as string
	if e > 127 Then
		return "" + str(e - 256)
	Else
		return "+" + str(e)
	End if
end function

function ixreg16a(r16 as integer, ixy as integer) as string
	If r16 = 2 Then
		Return ixreg(ixy)
	Else
		Return reg16a(r16)
	End If
end function

function ixreg8(r8 as integer, ixy as integer) as string
	' r8 = 6の時はこれで処理しない
	
	If r8 = 4 or r8 = 5 Then
		Return ixreg(ixy) + reg8(r8)
	Else
		Return reg8(r8)
	End If
end function

function make_numeric_constant(x as integer) as string
	If (x < 10) Then
		return str(x)
	ElseIf (x > 9 and x < 16) or (x > &h9f) Then
		return "0" + hex(x) + "h"
	else
		return hex(x) + "h"
	End If
end function

Sub out_text(s as string)
	output_line = s
End Sub