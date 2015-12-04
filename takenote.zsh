# vim: ft=zsh
# takenote - provide easy way to take note in the today's direcotry.

# Version:    v1.0
# Repository: https://github.com/ssh0/zsh-takenote
# Author:     ssh0 (Shotaro Fujimoto)
# License:    MIT

TAKENOTE_ROOTDIR="${TAKENOTE_ROOTDIR:-"$HOME/notes"}"
TAKENOTE_DAYDIR_FORMAT="${TAKENOTE_DAYDIR_FORMAT:-%Y-%m-%d}"
TAKENOTE_FILENAME_PRE="${TAKENOTE_FILENAME_PRE:-note_}"
TAKENOTE_FILENAME_NUMORDER=${TAKENOTE_FILENAME_NUMORDER:-2}
TAKENOTE_FILENAME_POST="${TAKENOTE_FILENAME_POST:-""}"
TAKENOTE_FILENAME_EXTENSION="${TAKENOTE_FILENAME_EXTENSION:-md}"
# This example makes a file like:
#   $HOME/notes/2015-11-27/note_01.md
#
TAKENOTE_AUTOCD=${TAKENOTE_AUTOCD:-true}
TAKENOTE_EDITORCMD=${TAKENOTE_EDITORCMD:-${EDITOR}}
TAKENOTE_FILERCMD=${TAKENOTE_FILERCMD:-"xdg-open"}

takenote() {

  local dir daydir filename editor
  local filercmd=${TAKENOTE_FILERCMD}
  local rootdir=${TAKENOTE_ROOTDIR}
  local pattern='s/'"${TAKENOTE_FILENAME_PRE}"'\([0-9]\{'"${TAKENOTE_FILENAME_NUMORDER}"'\}\)'"${TAKENOTE_FILENAME_POST}"'.'"${TAKENOTE_FILENAME_EXTENSION}"'/\1/p'

  show_usage() {
    echo ""
    echo "Usage: takenote [-d directory] [-o filename] [-g cmd] [-l] [-r] [-h]"
    echo ""
    echo "  -d dir     : Set the directory to save files (default: '${TAKENOTE_ROOTDIR}/$(date +"${TAKENOTE_DAYDIR_FORMAT}")')"
    echo "  -o filename: Set the file's name"
    echo "  -g editor  : Open with an altenative program (default: '${TAKENOTE_EDITORCMD}')"
    echo "  -l         : List the files in today's directory"
    echo "  -r         : Open the today's dir or the ROOT dir with file manager (default: '${TAKENOTE_FILERCMD}')"
    echo "  -h         : Show this message"
  }

  check_dir() {
    if [ ! -e "$1" ]; then
      echo "takenote: Directory '$1' doesn't exist."
      return 1
    else
      :
    fi
  }

  takenote_init() {
    # set the saving directory
    if [[ "${dir}" = "" ]]; then
      if check_dir "$rootdir"; then
        local daydir="$(date +"${TAKENOTE_DAYDIR_FORMAT}")"
        dir="$rootdir/$daydir"
      else
        return 1
      fi
    else
      :
    fi
  }

  takenote_showlist() {
    takenote_init || return 1
    # only show existing file in the directory
    if check_dir "$dir"; then
      list=$(ls "$dir")
      echo "$list"
    else
      :
    fi
  }

  takenote_openfiler() {
    takenote_init || return 1
    # move to today's directory by the user defined filer
    if check_dir "$dir"; then
      "$filercmd" "$dir"
    else
      echo "Open root directory '$rootdir' ..."
      "$filercmd" "$rootdir"
    fi
  }

  takenote_main() {
    takenote_init || return 1
    # set the filename
    if [[ "${filename}" = "" ]]; then
      if [ -e "$dir" ]; then
        i=$(( $(ls "$dir" | sed -n $pattern | tail -n 1) + 1 ))
      else
        i=1
      fi
      filename="$(printf ${TAKENOTE_FILENAME_PRE}%0${TAKENOTE_FILENAME_NUMORDER}d.${TAKENOTE_FILENAME_EXTENSION} "$i")"
    else
      :
    fi

    # show prompt "make dir ?"
    if check_dir "${dir}"; then
      takenote_edit
    else
      echo "takenote: Make the directory '$dir' ? [Y/n]"
      read -rq "confirm?>>> "
      if [ "$confirm" != "n" ]; then
        echo "\ntakenote: mkdir -p ${dir}"
        mkdir -p "${dir}"
        takenote_edit
      else
        echo "\nAborted."
        return 1
      fi
    fi
  }

  takenote_edit() {
    if ${TAKENOTE_AUTOCD}; then
      # change directory
      local cwd="`pwd`"
      cd "$dir"
    else
      :
    fi

    if [ -n "${editor}" ]; then
      $editor "$dir/$filename"
    elif [ -n "${TAKENOTE_EDITORCMD}" ]; then
      ${TAKENOTE_EDITORCMD} "$dir/$filename"
    else
      nano "$dir/$filename"
    fi

    if ${TAKENOTE_AUTOCD}; then
      # back to recent working directory
      cd "$cwd"
    else
      :
    fi
  }

  while getopts d:o:g:lrh OPT
  do
    case $OPT in
      "d" ) dir="$OPTARG"
            ;;
      "o" ) filename="$OPTARG"
            ;;
      "g" ) editor="$OPTARG"
            ;;
      "l" ) takenote_showlist
            return 0
            ;;
      "r" ) takenote_openfiler
            return 0
            ;;
      "h" ) show_usage
            return 0
            ;;
        * ) show_usage
            return 1
            ;;
    esac
  done

  takenote_main

  return 0
}

_takenote() {
  local pattern='s/\('"${TAKENOTE_FILENAME_PRE}"'[0-9]\{'"${TAKENOTE_FILENAME_NUMORDER}"'\}'"${TAKENOTE_FILENAME_POST}"'.'"${TAKENOTE_FILENAME_EXTENSION}"'\)/\1/p'
  typeset -A opt_args
  _arguments -S \
    "(-l -r -h)-d[Set the root directory to create day-directory.]:direcotry:_path_files -/" \
    "(-l -r -h)-o[Set the text file's name.]:files:( `takenote -l | sed -n $pattern` )" \
    "(-l -r -h)-g[Open with alternative program (default: '$EDITOR').]:editor:(vim leafpad nano gedit)" \
    "(-d -o -g -r -h)-l[Show the files in the today's directory.]: :" \
    "(-d -o -g -l -h)-r[Open the today's dir, or it doesn't exist, to the ROOT dir.]: :" \
    "(-d -o -g -l -r)-h[Show the help message.]: :" \
    && return 0
}

compdef _takenote takenote
