# Usage: ./stickerhax_geninc.sh <path to yellows8github/3ds_ropkit repo> <codebin path>

set -e

$1/generate_ropinclude.sh $2 $1

echo ""

printstr=`ropgadget_patternfinder $2 --baseaddr=0x100000 --patterntype=sha256 --patterndata=91c4752e988f8ce4b64f9ecbc17f8864314dfe661880e127473d23e72a957381 --patternsha256size=0x4 "--plainout=#define STACKPIVOT_ADR "`

if [[ $? -eq 0 ]]; then
	echo "$printstr"
else
	echo "//ERROR: STACKPIVOT_ADR not found."
	exit 1
fi

printstr=`ropgadget_patternfinder $2 --baseaddr=0x100000 --patterntype=sha256 --patterndata=dc74629ff3e859244262b1539190fe28e7146951cf1cfcd24d1cabca01e141d4 --patternsha256size=0x10 "--plainout=#define ROP_VTABLEFUNCPTR_x10_CALL_R5OBJ "`

if [[ $? -eq 0 ]]; then
	echo "$printstr"
else
	echo "//ERROR: ROP_VTABLEFUNCPTR_x10_CALL_R5OBJ not found."
	exit 1
fi

# Hard-coded for now.
echo -e "\n#define ROPBUF 0x082bcd54"
