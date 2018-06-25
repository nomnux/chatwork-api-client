#!/bin/sh

set -e

conf_file="$HOME/.chatwork/chatwork.conf"

print_usage() {
    cat << __USAGE 1>&2
Usage

  ${0##*/} [OPTION...] MESSAEGE

Options

    -f CONFIGURATION_FILE
        specify configuration file

    -v
        verbose mode

__USAGE

    exit 1
}

## ------------------------------------------------------------------------------

if [ $# -eq 0 ]; then
    print_usage
fi

while getopts f: opt; do
    case "$opt" in
        f) f_flag=enabled
           conf_file="$OPTARG"
           ;;
        *) print_usage
           ;;
    esac
done
shift `expr $OPTIND - 1`

msg="$1"

# read configuration file
. "$conf_file"

curl \
  -sS \
  -o /dev/null \
  -X POST \
  -H "X-ChatWorkToken: $token" \
  -d "body=$msg" \
  "https://api.chatwork.com/v2/rooms/${room_id}/messages"

exit 0
