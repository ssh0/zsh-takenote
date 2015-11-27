# takenote

:shell: Provide an easy way to take notes.

## Simple Usage

First, you should set your `$TAKENOTE_ROOTDIR` for saving your notes, like below:

```
export TAKENOTE_ROOTDIR="/path/you/want"
```

If you run

```
takenote
```

then, make the today's directory (like `/path/you/want/2015-11-27`, if it doesn't exist), and create the new file with a serial number (default: `note_01.md`, `note_02.md`, ... ) and edit it with `$EDITOR`.

## Other features and configurations

Some features are configurable without changing the source file.
You can change the environment variables in your `zshrc`.

### Set the directory location to save files

You can specify the takenote's root directory by `$TAKENOTE_ROOTDIR`.
This environment variable needs to be exported every time you log in zsh, so put the next line to `~/.zshrc`

```
TAKENOTE_ROOTDIR="$HOME/Workspace/blog"
```

(**default:** `$HOME/notes`)

Or, you can set the directory to save the files at the time you run the command.

```
takenote -d ~/path/to/directory
```

If you want to change the format of daydir, change this variable:

```
TAKENOTE_DAYDIR_FORMAT="%Y%m%d"
```

(**default:** `"%Y-%m-%d"`)

### Set the file name you want

Set the file name each time you run the command:

```
takenote -o filename.md
```

Or, if you'd like to use other format for the filenames, change these variables:

```
TAKENOTE_FILENAME_PRE="memo_"
TAKENOTE_FILENAME_POST="_file"
TAKENOTE_FILENAME_NUMORDER=3
TAKENOTE_FILENAME_EXTENSION="rst"
```

This makes `memo_001_file.rst`.

**default:**

```
TAKENOTE_FILENAME_PRE="note_"
TAKENOTE_FILENAME_POST=""
TAKENOTE_FILENAME_NUMORDER=2
TAKENOTE_FILENAME_EXTENSION="md"
```

### Open with specified program

You can set the command to open the file by changing:

```
TAKENOTE_EDITORCMD=gedit
```

(**default:** `$EDITOR`)

Or, provides the option temporarily

```
takenote -g gedit
```

### Open today's directory

```
takenote -r
```

with specified command:

```
TAKENOTE_FILERCMD=ranger
```

(**default:** "`xdg-open`")

### List all fils in today's directory

```
takenote -l
```

### Completion

This script also contains completion function.
Make sure after source this script, do

```
autoload -U compinit
compinit
```

## Install

### Manual install

* clone the repository  
```
git clone https://github.com/ssh0/zsh-takenote.git ~/.git/zsh-takenote
```

* source the script `takenote.zsh` from your `zshrc`

### With Antigen or other plugin manager

Add the line to your `zshrc` in order to load this plugin, like

```
antigen bundle ssh0/zsh-takenote
```

## Author

* [ssh0 (Shotaro Fujimoto)](https://github.com/ssh0)

Feel free to contact to me.

