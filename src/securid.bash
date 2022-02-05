#!/usr/bin/env bash
# pass securid - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2022 Subin Kim
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

VERSION="0.1.0"

cmd_securid_help() {
  cat << _EOF
Usage:

    $PROGRAM securid [code,show] [--clip,-c] pass-name
        Show a SecurID and optionally put it on the clipboard.
        If put on the clipboard, it will be cleared in $CLIP_TIME seconds.

    $PROGRAM securid insert [--force,-f] pass-name
        Insert new SecurID token.

    $PROGRAM securid append [--force,-f] pass-name
        Appends a SecurID token to an existing password file.

    $PROGRAM securid help
        Show this text.

    $PROGRAM securid version
        Show version information.

More information may be found in the pass-securid(1) man page.
_EOF
  exit 0
}

cmd_securid_version() {
  echo "pass-securid $VERSION"
  exit 0
}

case "$1" in
  help|--help|-h)    shift; cmd_securid_help "$@" ;;
  version|--version) shift; cmd_securid_version "$@" ;;
  insert)            shift; cmd_securid_insert "$@" ;;
  append)            shift; cmd_securid_append "$@" ;;
  code|show)         shift; cmd_securid_code "$@" ;;
  *)                        cmd_securid_code "$@" ;;
esac

exit 0
