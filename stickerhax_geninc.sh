# Usage: ./stickerhax_geninc.sh <path to yellows8github/3ds_ropkit repo> <codebin path>

$1/generate_ropinclude.sh $2 $1
if [[ $? -ne 0 ]]; then
	echo "//ERROR: 3ds_ropkit generate_ropinclude.sh returned an error."
	exit 1
fi

echo ""

printstr=`ropgadget_patternfinder $2 --baseaddr=0x100000 --patterntype=sha256 --patterndata=91c4752e988f8ce4b64f9ecbc17f8864314dfe661880e127473d23e72a957381 --patternsha256size=0x4 "--plainout=#define STACKPIVOT_ADR "`

if [[ $? -eq 0 ]]; then
	echo "$printstr"
else
	echo "//ERROR: STACKPIVOT_ADR not found."
	exit 1
fi

# For CHNTWN this should be defined as STACKPIVOT_ADR instead to workaround 0-byte in the addr.
printstr=`ropgadget_patternfinder $2 --baseaddr=0x100000 --patterntype=sha256 --patterndata=dc74629ff3e859244262b1539190fe28e7146951cf1cfcd24d1cabca01e141d4 --patternsha256size=0x10 "--plainout=#define ROP_VTABLEFUNCPTR_x10_CALL_R5OBJ "`

if [[ $? -eq 0 ]]; then
	echo "$printstr"
else
	echo "//ERROR: ROP_VTABLEFUNCPTR_x10_CALL_R5OBJ not found."
	exit 1
fi

# Hard-coded for now.
# USA = 0x082bcd54. EUR = 0x082be68c. JPN = 0x082bb450. KOR = 0x082bb480. CHNTWN = 0x082bc1f8.
echo -e "\n#define ROPBUF 0x082bcd54"
