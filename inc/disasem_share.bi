Dim Shared As String calc8( 7 )

calc8(0) = "ADD"
calc8(1) = "ADC"
calc8(2) = "SUB"
calc8(3) = "SBC"
calc8(4) = "AND"
calc8(5) = "XOR"
calc8(6) = "OR"
calc8(7) = "CP"

Dim Shared As String reg8( 7 )

reg8(0) = "B"
reg8(1) = "C"
reg8(2) = "D"
reg8(3) = "E"
reg8(4) = "H"
reg8(5) = "L"
reg8(6) = "(HL)"
reg8(7) = "A"

Dim Shared As String reg16( 3 )

reg16(0) = "BC"
reg16(1) = "DE"
reg16(2) = "HL"
reg16(3) = "SP"

Dim Shared As String reg16a( 3 )

reg16a(0) = "BC"
reg16a(1) = "DE"
reg16a(2) = "HL"
reg16a(3) = "AF"

Dim Shared As String ixreg( 2 )

ixreg(0) = "IX"
ixreg(1) = "IY"

Dim Shared As String rot0( 7 )

rot0(0) = "RLCA"
rot0(1) = "RRCA"
rot0(2) = "RLA"
rot0(3) = "RRA"
rot0(4) = "DAA"
rot0(5) = "CPL"
rot0(6) = "SCF"
rot0(7) = "CCF"

Dim Shared As String cond( 7 )

cond(0) = "NZ"
cond(1) = "Z"
cond(2) = "NC"
cond(3) = "C"
cond(4) = "PO"
cond(5) = "PE"
cond(6) = "P"
cond(7) = "M"

Dim Shared As String rot1( 7 )

rot1(0) = "RLC"
rot1(1) = "RRC"
rot1(2) = "RL"
rot1(3) = "RR"
rot1(4) = "SLA"
rot1(5) = "SRA"
rot1(6) = "SLL"
rot1(7) = "SRL"

dim shared as string bit0( 2 )

bit0(0) = "BIT"
bit0(1) = "RES"
bit0(2) = "SET"

dim shared as string repti( 3 )

repti(0) = "LDI"
repti(1) = "CPI"
repti(2) = "INI"
repti(3) = "OUTI"

dim shared as string reptd( 3 )

reptd(0) = "LDD"
reptd(1) = "CPD"
reptd(2) = "IND"
reptd(3) = "OUTD"

dim shared as string reptir( 3 )

reptir(0) = "LDIR"
reptir(1) = "CPIR"
reptir(2) = "INIR"
reptir(3) = "OTIR"

dim shared as string reptdr( 3 )

reptdr(0) = "LDDR"
reptdr(1) = "CPDR"
reptdr(2) = "INDR"
reptdr(3) = "OTDR"