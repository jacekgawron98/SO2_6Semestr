
#!/bin/bash -eu

DIR_NOT_FOUND=3
NOT_ENOUGH_PARAMETERS=4

if [[ $# -lt 1 ]]; then
	echo "1 parameter needed"
	exit "${NOT_ENOUGH_PARAMETERS}"
fi

SOURCE_DIR=${1}

if [[ ! -d ${SOURCE_DIR} ]]; then
	echo "${SOURCE_DIR} is not a directory"
	exit "${DIR_NOT_FOUND}"
fi

for FILE in $(ls ${SOURCE_DIR})
do
   	if [[ -d ${SOURCE_DIR}/${FILE} ]] && [[ ${FILE: -4} == .bak ]]; then
		chmod ug-x,o+x ${SOURCE_DIR}/${FILE}
	fi

	if [[ -f ${SOURCE_DIR}/${FILE} ]] && [[ ${FILE: -4} == .bak ]] ; then
		chmod uo-x ${SOURCE_DIR}/${FILE}
	fi

	if [[ -d ${SOURCE_DIR}/${FILE} ]] && [[ ${FILE: -4} == .tmp ]]; then
		chmod +w ${SOURCE_DIR}/${FILE}
	fi

	if [[ -f ${SOURCE_DIR}/${FILE} ]] && [[ ${FILE: -4} == .txt ]]; then
		chmod u=r,g=w,o=x ${SOURCE_DIR}/${FILE}
	fi

	if [[ -f ${SOURCE_DIR}/${FILE} ]] && [[ ${FILE: -4} == .exe ]]; then
		chmod +x ${SOURCE_DIR}/${FILE}
	fi
done
