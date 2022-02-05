PASSWORD_STORE_EXTENSION_COMMANDS+=(securid)

__password_store_extension_complete_securid() {
  local subs=(insert append)

  if [[ $COMP_CWORD -gt 2 ]]; then
    case "${COMP_WORDS[2]}" in
      insert|append)
        COMPREPLY+=($(compgen -W "-f --force" -- ${cur}))
        _pass_complete_entries
        ;;
      *)
        COMPREPLY+=($(compgen -W "-h --help" -- ${cur}))
        _pass_complete_entries
        ;;
    esac
  else
    COMPREPLY+=($(compgen -W "${subs[*]} -h --help -c --clip" -- ${cur}))
    _pass_complete_entries 1
  fi
}
