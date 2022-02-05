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

cmd_version() {
    echo "pass-securid $VERSION"
    exit 0
}

case "$1" in
  help|--help|-h)    shift; cmd_help "$@" ;;
  version|--version) shift; cmd_version "$@" ;;
  insert)            shift; cmd_insert "$@" ;;
  append)            shift; cmd_append "$@" ;;
  code|show)         shift; cmd_code "$@" ;;
  *)                        cmd_code "$@" ;;
esac

exit 0
