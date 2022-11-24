' ================================================================================
' Enum
' ================================================================================
Enum adrs_type
	immediate_data = 1
	direct_access = 2
	direct_access_8 = 3
	jp_label = 4
	call_label = 5
End Enum

Enum msg_type
	byte_data = 1
	word_data = 2
	msg_data = 3
	zero_data = 4
End Enum

' ================================================================================
' Type 
' ================================================================================
Type adrs_wrk_t
	st As Integer
	sz As Integer
	dt As UByte
	t As adrs_type
End Type

Type msg_wrk_t
	st As Integer
	ed As Integer
	t As Integer
End Type

' ================================================================================
' Const
' ================================================================================
Const buffer_size = 1024 * 64
Const adrs_wrk_size = 1000 * 4
Const msg_wrk_size = 1000 * 4

' ================================================================================
' Global
' ================================================================================
Dim Shared As Integer adrs_offset = 0

Dim Shared As Integer adrs_wrk_cnt = 0
Dim Shared As adrs_wrk_t adrs_wrk( adrs_wrk_size )

Dim Shared As Integer msg_wrk_cnt = 0
Dim Shared As msg_wrk_t msg_wrk( msg_wrk_size )

Dim Shared As String output_line
Dim Shared As Integer buffer_start
Dim Shared As Integer buffer_end
Dim Shared As Integer gen_pass = 0
Dim shared as Boolean after_call_ope = False
Dim shared as Integer last_call_adrs = 0

dim shared as ubyte ptr buffer
' ================================================================================
' Sub & Function
' ================================================================================
Declare Sub cmd_read_file()
Declare Sub cmd_dump_memory()
Declare Sub cmd_disasem()
Declare Sub cmd_gen_source()
Declare Sub cmd_set_label()
Declare Sub cmd_set_message()
Declare Sub cmd_disp_adrs()
Declare Sub cmd_disp_label()
Declare Sub cmd_disp_message()

Declare Function disasem(mem As UByte Ptr, st As Integer) As Integer
Declare Function disasem_cb(mem As UByte Ptr, st As Integer) As Integer
Declare Function disasem_ed(mem As UByte Ptr, st As Integer) As Integer
Declare Function disasem_ixy(mem As UByte Ptr, st As Integer, ixy As Integer) As Integer
Declare Function disasem_ixy_cb(mem As UByte Ptr, st As Integer, ixy As Integer) As Integer

Declare function relativ(st as integer, e as ubyte) as integer
Declare function dsp(e as ubyte) as string

Declare function ixreg16a(r16 as integer, ixy as integer) as string
Declare function ixreg8(r8 as integer, ixy as integer) as string

Declare Sub out_text(s as string)

Declare function check_label(x as integer) as Boolean
Declare function search_label(x as integer) as adrs_wrk_t
Declare function make_label(x as integer, t as adrs_type, sz as integer = -1 , dt as integer = -1) as string

Declare function check_msg(x as integer) as Boolean
Declare function search_msg(x as integer) as msg_wrk_t
Declare function make_msg(x as integer, sz as integer, t as msg_type) as string

Declare function make_numeric_constant(x as integer) as string

Declare function is_display(c as ubyte) as boolean
Declare function _min(a as integer, b as integer) as integer

Declare function hex4(x as integer) as string
Declare function hex2(x as integer) as string

Declare function dump4(mem as ubyte ptr, st as integer, l as integer) as string
Declare function dump8(mem as ubyte ptr, st as integer, l as integer) as string

Declare function search_ubyte(mem as ubyte ptr, st as integer, dt as integer) as Integer
Declare function make_message(mem as ubyte ptr, st as integer, sz as integer) as string



