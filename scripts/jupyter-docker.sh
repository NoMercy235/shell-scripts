#!/bin/bash

function usage () {
	echo "$(basename "$0") [-v s] [-p n]

	Script used to automate some parts of the daily development process

	Where:
	    -v (string) the path used to save the Jupyter files.
	    -p (string) The port used by Jupyter
	" 1>&2
	exit 1
}

declare volume=
declare port=8888

while getopts "v:p:" opt; do
	case $opt in
		v)
			# TODO: error handling and other options
			volume="${OPTARG}"
			;;
		p)
			port="${OPTARG}"
			;;
		\?)
		        usage
			;;
	esac
done

if [[ -z "${volume}" ]]; then
	usage
fi

docker run -i -t -p ${port}:8888 -v ${volume}:/opt/notebooks continuumio/anaconda3 /bin/bash -c "/opt/conda/bin/conda install jupyter -y --quiet && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root"

