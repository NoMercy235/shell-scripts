#!/bin/bash

function usage () {
	echo "$(basename "$0") [-i s] [-s s] [-b s] [-a s]

	Script used to automate some parts of the daily development process

	Where:
	    -i (string) the IDE used (defaults to 'webstorm'). Accepted values: 'phpstorm', 'webstorm', 'sublime', 'code', 'atom'
	    -s (string) the social app (no default). If no values is present here and there is no browser source, then the URL for slack will also be opened. Accepted values: 'slack', 'franz', 'skype'
	    -b (string) the browser used (defaults to 'google-chome'). Accepted values: 'chrome', 'google-chrome', 'firefox', 'mozilla' and 'mozilla-firefox'
	    -a (string) browser source. This is a file which contains one URL per line that overrides the base URLs when opening the browser.
	" 1>&2
	exit 1
}

declare social="slack"
declare ide="webstorm"
declare browser="google-chrome"
declare browserSource=

# Joins an array into a string using the given joiner.
function join_by { local IFS="$1"; shift; echo "$*"; }

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
			array=( "phpstorm" "webstorm" "sublime" "code" "atom" )
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


# If the user has provided a source for links, use that instead.
urls=
if [[ ! -z "$browserSource" ]]; then
	urls=()
	while IFS= read -r line; do
		urls+=("$line")
	done < "$browserSource"
	unset IFS
else
	urls=( "https://intralinks.onelogin.com/portal/" "https://www.youtube.com/" "https://mail.google.com/mail/u/1/#inbox" "https://github.com/" "https://stackoverflow.com/" )
fi

case $browser in
	"chrome" | "google-chrome" | "google")
		urlList=$(join_by " " ${urls[@]})
		/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --new-window $urlList &
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
case $social in
        "slack")
                /Applications/Slack.app/Contents/MacOS/Slack
                ;;
        \?)
                # TODO: error message
                exit 1
                ;;
esac

case $ide in
        "code")
                code
                ;;
        "atom")
                /Applications/Atom.app/Contents/MacOS/Atom
                ;;
        \?)
                # TODO: error message
                exit 1
                ;;
esac

exit 0
