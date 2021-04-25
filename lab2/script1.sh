S#!/bin/bash -eu

DIR_NOT_FOUND=3
NOT_ENOUGH_PARAMETERS=4

SOURCE_DIR=${1}
LINK_DIR=${2}

if [[ -z ${1} ]] || [[ -z ${2} ]]; then
	echo "2 parameters needed"
	exit "${NOT_ENOUGH_PARAMETERS}"
fi

if [[ ! -d ${SOURCE_DIR} ]] || [[ ! -d ${LINK_DIR} ]]; then
	[[ ! -d ${SOURCE_DIR} ]] && echo "Directory ${SOURCE_DIR} does not exist"
	[[ ! -d ${LINK_DIR} ]] && echo "Directory ${LINK_DIR} does not exist"
	exit "${DIR_NOT_FOUND"
fi

for FILE in $(ls ${SOURCE_DIR}) 
do
	EXT=${FILE##*.}
	FILENAME=${FILE%.*}
	if [[ ${FILENAME} != ${FILE} ]]; then
		OUTPUT_FILE=${LINK_DIR}/${FILENAME^^}_ln.${EXT}
	else
		OUTPUT_FILE=${LINK_DIR}/${FILENAME^^}_ln
	fi

	if [[ -d ${SOURCE_DIR}/${FILE} ]]; then
		echo "${FILE} is a directory"
		ln -s ${SOURCE_DIR}/${FILE} ${OUTPUT_FILE}
	elif [[ -L ${SOURCE_DIR}/${FILE} ]]; then
		echo "${FILE} is a symbolic link"
	else
		echo "${FILE} is a regular file"
		ln -s ${SOURCE_DIR}/${FILE} ${OUTPUT_FILE}
	fi
	
done
