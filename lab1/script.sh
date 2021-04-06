#!/bin/bash -eu

SOURCE_DIR=${1:-lab_uno}
RM_LIST=${2:-lab_uno/2remove}
TARGET_DIR=${3:-bakap}

mkdir -p ${TARGET_DIR}
for NAME in $(cat ${RM_LIST})
do
	rm -frv ${SOURCE_DIR}/${NAME}
done
for FILE in $(ls ${SOURCE_DIR})
do
	if [[ -f ${SOURCE_DIR}/${FILE} ]]; then
		mv ${SOURCE_DIR}/${FILE} ${TARGET_DIR}/${FILE}
	elif [[ -d ${SOURCE_DIR}/${FILE} ]]; then
		cp -R ${SOURCE_DIR}/${FILE} ${TARGET_DIR}/${FILE}
	else
		echo "FILE ERROR"
	fi
done
COUNT=$(ls ${SOURCE_DIR} | wc -l)
if [[ ${COUNT} -gt 0 ]]; then
	echo "Coś zostało"
else
	echo "Tu był Kononowicz"
fi
if [[ ${COUNT} -ge 2 ]]; then
	echo "Zostały co najmniej 2 pliki"
elif [[ ${COUNT} -gt 4 ]]; then
	echo "Zostało więcej niż 4 pliki"
fi
for FILE in $(ls ${TARGET_DIR})
do
	chmod -w ${TARGET_DIR}/${FILE}
done
ZIP_DATE=$(date +%F)
zip -r ${TARGET_DIR}_${ZIP_DATE}.zip ${TARGET_DIR}
