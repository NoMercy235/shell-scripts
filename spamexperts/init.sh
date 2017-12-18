#!/bin/bash

if ! type python > /dev/null 2>&1; then
        echo "Python is missing."
	exit 1
fi

function usage () {
	echo "$(basename "$0") [-m s] [-i s] [-s s] [-b s] [-a s]

	Script used to automate some parts of the daily development process

	Where:
	    -m (string) the mode of assign-server.py script (defaults to '--assign-highest'). See the script for more usage examples
	    -i (string) the IDE used (defaults to 'phpstorm'). Accepted values: 'phpstorm', 'webstorm', 'sublime'
	    -s (string) the social app (no default). If no values is present here and there is no browser source, then the URL for slack will also be opened. Accepted values: 'slack', 'franz', 'skype'
	    -b (string) the browser used (defaults to 'google-chome'). Accepted values: 'chrome', 'google-chrome', 'firefox', 'mozilla' and 'mozilla-firefox'
	    -a (string) browser source. This is a file which contains one URL per line that overrides the base URLs when opening the browser.
	" 1>&2
	exit 1
}

declare mode="--assign-highest"
declare social="slack"
declare ide="phpstorm"
declare browser="google-chrome"
declare browserSource=

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

function contains_element () {
	local e match="$1"
	shift
	for e; do [[ "$e" == "$match" ]] && return 0; done
	return 1
}

while getopts "m:i:s:b:a:" opt; do
	case $opt in
		m)
			# TODO: error handling and other options
			mode=--"${OPTARG}"
			;;
		i)
			ide="${OPTARG}"
			array=( "phpstorm" "webstorm" "sublime" )
			contains_element $ide ${array[@]} || usage
			;;
		s)
			social="${OPTARG}"
			array=( "slack" "franz" "skype" )
			contains_element $social ${array[@]} || usage
			;;
		b)
			browser="${OPTARG}"
			array=( "chome" "google" "google-chrome" "mozilla" "firefox" "mozilla-firefox" )
			contains_element $browser ${array[@]} || usage
			;;
		a)
			# TODO: error handling and other options
			browserSource="${OPTARG}"
			;;
		\?)
		        usage
			;;
	esac
done

# Assigning a server using the Python script.
# The result looks like this: server1.testXX.simplyspamfree.com
# Split the result by "." and get the second group, then remove all non-digit characters.
IFS="." assignedServer=($((python ${SCRIPTPATH}/assign-server.py "${mode}") 2>&1))
unset IFS
serverId=${assignedServer[1]//[!0-9]/}
echo "Assigned server: ${serverId}"

# Joins an array into a string using the given joiner.
function join_by { local IFS="$1"; shift; echo "$*"; }

assignedServer=$serverId

# If the user has provided a source for links, use that instead.
urls=
if [[ ! -z "$browserSource" ]]; then
	urls=()
	while IFS= read -r line; do
		urls+=("$line")
	done < "$browserSource"
	unset IFS
else
	urls=( "https://mail.google.com/mail/u/0/#inbox" "https://calendar.google.com/calendar/" "https://testservers.seinternal.com" "http://trac.spamexperts.com/report/6" "https://server1.test${assignedServer}.simplyspamfree.com" "https://discourse.seinternal.com/" )

	# If there is no social selected, open the slack url as well
	if [[ -z "$social" ]]; then
		urls+=( "https://spamexperts.slack.com" )
	fi
fi

case $browser in
	"chrome" | "google-chrome" | "google")
		urlList=$(join_by " " ${urls[@]})
		google-chrome --new-window $urlList &
		;;
	"firefox" | "mozilla" | "mozilla-firefos")
		firefox -new-tab  $urlList &
		;;
	\?)
		# TODO: error message
		exit 1
		;;
esac

# Start social
[[ ! -z $social ]] && $social &

# Start IDE
[[ ! -z $ide ]] && $ide &

stacer &

exit 0

