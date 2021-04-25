#!/bin/bash -eu

NOT_DIR_ERROR=3
NOT_ENOUGH_PARAMETERS=4

if [[ $# -lt 2 ]]; then
	echo "2 parameters needed"
	exit "${NOT_ENOUGH_PARAMETERS}"
fi

SOURCE_DIR=${1}
RESULT_FILE=${2}

if [[ ! -d ${SOURCE_DIR} ]]; then
	echo "${SOURCE_DIR} is not a directory"
	exit "${NOT_DIR_ERROR}"
fi

echo $(date --iso-8601) >> ${RESULT_FILE}
for FILE in $(ls ${SOURCE_DIR})
do
	if [[ -L ${SOURCE_DIR}/${FILE} ]]; then
		if [[ ! -e ${SOURCE_DIR}/${FILE} ]]; then
			echo "Link ${FILE} is broken. Removing..."
			echo ${FILE} >> ${RESULT_FILE}
			rm ${SOURCE_DIR}/${FILE}
		fi
	fi
done
