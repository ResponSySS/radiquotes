#!/bin/bash -
#===============================================================================
#
#         USAGE: ./this.sh --help
#
#   DESCRIPTION: RTFM (--help)
#  REQUIREMENTS: twurl, make, sed, shuf
#        AUTHOR: Sylvain S. (ResponSyS), mail@sylsau.com
#       CREATED: 04/05/2018 02:28:35 PM
#===============================================================================

# TODO:
# 	check that every arg is a file before processing

set -o errexit

readonly LIBSYL=${LIBSYL:-$HOME/Devel/Src/radiquotes/libsyl.sh}
source "$LIBSYL"

readonly VERSION=0.9

# 'twurl' command
readonly TWURL=${TWURL:-/usr/local/bin/twurl}
FILE_TO_UPLOAD=
# Media id string
MEDIA_IDS=
# Twitter status
STATUS=
FILE_LOG="${TMP_DIR}/radiquotes-tweet.log"
# Error codes
readonly ERR_PARSE_AUTHOR=11
readonly ERR_UPLOAD=22
readonly ERR_POST=33

# Print help
fn_show_help() {
    cat << EOF
$SCRIPT_NAME $VERSION
    Radiquote tweeter for Aufhebung.
USAGE
    $SCRIPT_NAME [--help] [--preview] {FILE} ...
DESCRIPTION
    Tweets quote image FILE. If more than one FILE, pick a random one.
    --preview           show image before tweeting it via \`xdg-open\`
AUTHOR
    Collectif Aufhebung: <http://aufhebung.fr>
    Written by Sylvain Saubier (<http://SystemicResponse.com>)
    Report bugs at: <feedback@sylsau.com>
EOF
}

# $@: array of filenames
fn_get_random_file() {
	if [[ $# -eq 1 ]]; then
	       	RET="$1"
	else
		# Store args in array with QUOTED $@ (to escape spaces)
		local ARGS=( "$@" )
		local I_MAX=
		local I_RAND=
		let "I_MAX  = $#"
		let "I_RAND = $RANDOM % $I_MAX"
		# Return number $I_RAND in args array
		RET="${ARGS[$I_RAND]}"
	fi
}
# $1: filename of quote image
fn_get_author() {
	RET="$( basename "$1" | cut -d '-' -f1 | tr '_' ' ' )"
}
# $1: filename of quote image
fn_upload_quote() {
	RET="$( $TWURL -X POST -H "upload.twitter.com" "/1.1/media/upload.json" -f "$1" -F media 2>$FILE_LOG \
		| sed 's/{.*\"media_id\":\([0-9]\+\).*}/\1/gp' -n )"
}
# $1: media id of image to post
fn_post_quote() {
	$TWURL -X POST "/1.1/statuses/update.json" -d "media_ids=$MEDIA_IDS&status=$STATUS"
	RET=$?
}

fn_tweet() {
	# Get a random filename argument
	fn_get_random_file "$@"
	[[ $RET ]] || 	syl_exit_err "Can't get random argument from '$@'" $ERR_WRONG_ARG
	FILE_TO_UPLOAD="$RET"
	[[ $PREVIEW ]] && xdg-open "$FILE_TO_UPLOAD"
	# Get status (author) from filename
	fn_get_author "$FILE_TO_UPLOAD"
	[[ $RET ]] || 	syl_exit_err "Can't get author from file '$FILE_TO_UPLOAD'" $ERR_PARSE_AUTHOR
	STATUS="$RET"
	# Announcing post
	msyl_say "Posting '$FILE_TO_UPLOAD' with \"$STATUS\" in:"
	for i in `seq 5 -1 1`; do echo -n "$i.." && sleep 1 ; done
	echo
	# Upload image on twatter
	fn_upload_quote "$FILE_TO_UPLOAD"
	[[ $RET ]] || 	syl_exit_err "Error when uploading file '$FILE_TO_UPLOAD'; please see '$FILE_LOG'" $ERR_UPLOAD
	MEDIA_IDS="$RET"
	# Update status with uploaded image
	fn_post_quote "$MEDIA_IDS"
	[[ $RET ]] || 	syl_exit_err "Can't tweet with media id '$MEDIA_IDS'" $ERR_POST
}


main() {
	syl_need_cmd "$TWURL"
	syl_need_cmd "sed"
	syl_need_cmd "make"

	# Parse arguments
	local SHOW_HELP=
	local PREVIEW=
	[[ "$1" = "--preview"  ]] && 	{ PREVIEW=1 ; shift ; }
	[[ "$1" =~ ^-(h|-help)$  ]] && 	SHOW_HELP=1
	[[ $# -eq 0 ]] 		  && 	SHOW_HELP=1
	[[ $SHOW_HELP ]]&& 	{ fn_show_help ; exit ; }

	fn_tweet "$@"
	msyl_say "\nJust tweeted!"
}

main "$@"
