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

securid_read_token() {
  local token_again name="$1"

  read -r -p "Enter SecurID token for $name: " -s token || exit 1
  echo
  read -r -p "Retype SecurID token for $name: " -s token_again || exit 1
  echo
  [[ "$token" == "$token_again" ]] || die "Error: the entered tokens do not match."

  # TODO: Add token validation
}

securid_read_pin() {
  local pin_again name="$1"

  read -r -p "Enter SecurID PIN for $name (default: 0000): " -s pin || exit 1
  echo
  read -r -p "Retype SecurID PIN for $name (default: 0000): " -s pin_again || exit 1
  echo
  pin=${pin:-0000}
  pin_again=${pin:-0000}
  [[ "$pin" == "$pin_again" ]] || die "Error: the entered pins do not match."
}

securid_serialize() {
  local token="$1" pin="$2"
  contents="SecurID Token: $token"$'\n'"SecurID PIN: $pin"
}

securid_deserialize() {
  local contents="$1"
  local token_pattern='SecurID[[:space:]]Token:[[:space:]]?([^'$'\n'']*)'
  local pin_pattern='SecurID[[:space:]]PIN:[[:space:]]?([^'$'\n'']*)'

  [[ $contents =~ $token_pattern ]]
  token=${BASH_REMATCH[1]}

  [[ $contents =~ $pin_pattern ]]
  pin=${BASH_REMATCH[1]}
}

securid_insert() {
  local path="$1" passfile="$2" contents="$3" message="$4"

  check_sneaky_paths "$path"
  set_git "$passfile"

  mkdir -p -v "$PREFIX/$(dirname -- "$path")"
  set_gpg_recipients "$(dirname -- "$path")"

  echo "$contents" | $GPG -e "${GPG_RECIPIENT_ARGS[@]}" -o "$passfile" "${GPG_OPTS[@]}" || die "Password encryption aborted."

  git_add_file "$passfile" "$message"
}

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

cmd_securid_insert() {
  local opts force=0
  opts="$($GETOPT -o f: -l force: -n "$PROGRAM" -- "$@")"
  local err=$?
  eval set -- "$opts"
  while true; do case $1 in
    -f|--force) force=1; shift ;;
    --) shift; break ;;
  esac done

  [[ $err -ne 0 ]] && die "Usage: $PROGRAM $COMMAND insert [--force,-f] [pass-name]"

  local path
  if [[ $# -eq 1 ]]; then
    path="${1%/}"
  else
    read -r -p "Enter pass name: " path || exit 1
  fi

  securid_read_token "$path"
  securid_read_pin "$path"
  securid_serialize "$token" "$pin"

  contents=$'\n'"$contents"

  local passfile="$PREFIX/$path.gpg"
  [[ $force -eq 0 && -e $passfile ]] && yesno "An entry already exists for $path. Overwrite it?"

  securid_insert "$path" "$passfile" "$contents" "Add SecurID token for $path to store."
}

cmd_securid_append() {
  local opts force=0
  opts="$($GETOPT -o f: -l force: -n "$PROGRAM" -- "$@")"
  local err=$?
  eval set -- "$opts"
  while true; do case $1 in
    -f|--force) force=1; shift ;;
    --) shift; break ;;
  esac done

  [[ $err -ne 0 || $# -ne 1 ]] && die "Usage: $PROGRAM $COMMAND append [--force,-f] pass-name"

  local path="${1%/}"
  local passfile="$PREFIX/$path.gpg"

  [[ -f $passfile ]] || die "Error: $path is not in the password store."

  local result
  result="$($GPG -d "${GPG_OPTS[@]}" "$passfile")"
  securid_deserialize "$result"

  [[ -n "$token" || -n "$pin" ]] && yesno "A SecurID Token or PIN already exists for $path. Overwrite it?"

  securid_read_token "$path"
  securid_read_pin "$path"
  securid_serialize "$token" "$pin"

  result="$(echo "$result" | sed '/^SecurID Token.*$/d' | sed '/^SecurID PIN.*$/d')"
  contents="$result"$'\n'"$contents"

  local passfile="$PREFIX/$path.gpg"

  securid_insert "$path" "$passfile" "$contents" "Append SecurID token for $path to store."
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
