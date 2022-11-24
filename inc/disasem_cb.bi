function disasem_cb(mem as ubyte ptr, st as integer) as integer
	
	dim as ubyte c = mem[st]
	dim as integer d = (c and &hc0) / 64
	dim as integer r0 = (c and &h38) / 8
	dim as integer r1 = (c and &h7)
	
	If d = 0 THen
		out_text rot1(r0) + " " + reg8(r1)
	Else
		out_text bit0(d-1) + " " + str(r0) + "," + reg8(r1)
	End If
	
	return 2
	
end function