' ================================================================================
' Enum
' ================================================================================
ENUM adrs_type
	immediate_data = 1
	direct_access = 2
	direct_access_8 = 3
	jp_label = 4
	call_label = 5
END ENUM

ENUM msg_type
	byte_data = 1
	word_data = 2
	msg_data = 3
	zero_data = 4
END ENUM

ENUM binary_file_type
    raw_data = 0
	cpm_command = 1 
	sos_binary = 2
	mzt_format = 3
	mzf_format = 4
END ENUM

' ================================================================================
' Type 
' ================================================================================
TYPE adrs_wrk_t
	st AS INTEGER
	sz AS INTEGER
	dt AS UBYTE
	t AS adrs_type
END TYPE

TYPE msg_wrk_t
	st AS INTEGER
	ed AS INTEGER
	t AS msg_type
END TYPE

' ================================================================================
' Const
' ================================================================================
CONST buffer_size = 1024 * 64
CONST adrs_wrk_size = 1000 * 4
CONST msg_wrk_size = 1000 * 4

' ================================================================================
' Global
' ================================================================================
DIM SHARED AS INTEGER adrs_offset = 0

DIM SHARED AS INTEGER adrs_wrk_cnt = 0
DIM SHARED AS adrs_wrk_t adrs_wrk( adrs_wrk_size )

DIM SHARED AS INTEGER msg_wrk_cnt = 0
DIM SHARED AS msg_wrk_t msg_wrk( msg_wrk_size )

DIM SHARED AS STRING output_line
DIM SHARED AS INTEGER buffer_start = 0
DIM SHARED AS INTEGER buffer_end = 0
DIM SHARED AS INTEGER gen_pass = 0
DIM SHARED AS BOOLEAN after_call_ope = FALSE
DIM SHARED AS INTEGER last_call_adrs = 0

DIM SHARED AS UBYTE PTR buffer
DIM SHARED AS INTEGER ftype = -1

' ================================================================================
' Sub & Function
' ================================================================================
DECLARE SUB cmd_read_file()
DECLARE SUB cmd_dump_memory()
DECLARE SUB cmd_disasem()
DECLARE SUB cmd_gen_source()
DECLARE SUB cmd_set_label()
DECLARE SUB cmd_set_message()
DECLARE SUB cmd_disp_adrs()
DECLARE SUB cmd_disp_label()
DECLARE SUB cmd_disp_message()

DECLARE FUNCTION disasem(mem AS UBYTE PTR, st AS INTEGER) AS INTEGER
DECLARE FUNCTION disasem_cb(mem AS UBYTE PTR, st AS INTEGER) AS INTEGER
DECLARE FUNCTION disasem_ed(mem AS UBYTE PTR, st AS INTEGER) AS INTEGER
DECLARE FUNCTION disasem_ixy(mem AS UBYTE PTR, st AS INTEGER, ixy AS INTEGER) AS INTEGER
DECLARE FUNCTION disasem_ixy_cb(mem AS UBYTE PTR, st AS INTEGER, ixy AS INTEGER) AS INTEGER

DECLARE FUNCTION relativ(st AS INTEGER, e AS UBYTE) AS INTEGER
DECLARE FUNCTION dsp(e AS UBYTE) AS STRING

DECLARE FUNCTION ixreg16a(r16 AS INTEGER, ixy AS INTEGER) AS STRING
DECLARE FUNCTION ixreg8(r8 AS INTEGER, ixy AS INTEGER) AS STRING

DECLARE SUB out_text(s AS STRING)

DECLARE FUNCTION search_label(x AS INTEGER) AS INTEGER
DECLARE FUNCTION make_label(x AS INTEGER, t AS adrs_type, sz AS INTEGER = -1 , dt AS INTEGER = -1) AS STRING

DECLARE FUNCTION search_msg(x AS INTEGER) AS INTEGER
DECLARE FUNCTION make_msg(x AS INTEGER, sz AS INTEGER, t AS msg_type) AS STRING

DECLARE FUNCTION make_numeric_constant(x AS INTEGER) AS STRING

DECLARE FUNCTION is_display(c AS UBYTE) AS BOOLEAN
DECLARE FUNCTION _min(a AS INTEGER, b AS INTEGER) AS INTEGER

DECLARE FUNCTION hex4(x AS INTEGER) AS STRING
DECLARE FUNCTION hex2(x AS INTEGER) AS STRING

DECLARE FUNCTION dump4(mem AS UBYTE PTR, st AS INTEGER, l AS INTEGER) AS STRING
DECLARE FUNCTION dump8(mem AS UBYTE PTR, st AS INTEGER, l AS INTEGER) AS STRING

DECLARE FUNCTION search_ubyte(mem AS UBYTE PTR, st AS INTEGER, dt AS INTEGER) AS INTEGER
DECLARE FUNCTION make_message(mem AS UBYTE PTR, st AS INTEGER, sz AS INTEGER) AS STRING

DECLARE FUNCTION read_file(file_name as string) AS BOOLEAN
DECLARE FUNCTION read_sos_binary() AS BOOLEAN
DECLARE FUNCTION read_mzt_binary() AS BOOLEAN
DECLARE FUNCTION read_mzf_binary() AS BOOLEAN

DECLARE SUB ge_source_pass_1()
DECLARE SUB ge_source_pass_2(out_file_name AS STRING)
