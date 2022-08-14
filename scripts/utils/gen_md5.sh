#!/bin/bash

set -eu



MD5SUM_FILE_PATH="/tmp/md5sum_info.txt"

if [ $# -ne 1 ]
then
    echo "Usage: $0 [file|dir]"
    exit 2
fi

path=$1
if [ ! -e ${path} ];then
    echo "[Error] ${path} not found."
    exit 1
fi

if [ -d ${path} ];then
    echo "[INFO] generate md5sum for directory ${path} recursively."
    find ${path} -type f | sort | while read line
    do
        md5sum "${line}" >> "${MD5SUM_FILE_PATH}"
    done
fi

if [ -f ${path} ];then
    echo "[INFO] generate md5sum for file ${path}."
    md5sum "${line}" >> "${MD5SUM_FILE_PATH}"
fi
