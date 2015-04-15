#!/bin/bash
source $HIPPIE_INI
source $HIPPIE_CFG

FILE=$1
LINE=$2


if [ !  -s "${FILE}" ]
then
 echo "Cannot find input file $FILE!"
 exit 100
fi


echo "[`date`] Concating the file of ${LINE}......"

cut -f1-3,7 $FILE > "${LINE}_concat_temp.txt"
cut -f4-7 $FILE >> "${LINE}_concat_temp.txt"

echo "[`date`] Generating sorted bed file"
sort -T $TMPDIR -k 1,1 -k 2,2n "${LINE}_concat_temp.txt" > "${LINE}_concat.bed"
rm "${LINE}_concat_temp.txt"

echo "[`date`] Getting consecutive file of ${LINE}"
$BEDTOOLS merge -i "${LINE}_concat.bed" -c 4 -o collapse,count > "${LINE}_consecutive.bed"

EXITSTATUS=$?

if [ !  -s "${LINE}_consecutive.bed" ]
then
 echo "Incorrect Output!"
 exit 100
fi

exit $EXITSTATUS


