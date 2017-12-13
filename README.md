
# .DotFiles

## Description

In this repository, DotFiles is several bash commands (scripts) for management
of user's dotfiles (example `~/.vimrc`, `~/.bashrc` and another), based on
symlinks. This commands have bash auto completion. For getting help use
command `dotfiles help`.

**WARNING:** backup your files :) I need help for test it.

## Example to use it

### Install

#### Install separately

1.  Make directory for your dotfiles. Example:

    ```bash
    $ mkdir ~/.dotfiles
    ```

2.  Clone this repository to local directory (example: `~/dotfiles_script`,
    or another)

    ```bash
    $ git clone https://bitbucket.org/GentleFly/dotfiles ~/dotfiles_script
    ```

3.  In your `~/.bashrc`, define name of directory for yours dotfiles and add
    `dotfiles.sh` as source:

    ```bash
    # Define path for yours dotfiles:
    export DOTFILES_DIR="$HOME/.dotfiles"
    # Include bash script `dotfiles.sh`:
    if [[ -f ${HOME}/dotfiles_script/dotfiles.sh ]] ; then
        source ${HOME}/dotfiles_script/dotfiles.sh
    fi
    # for use once times, use this line in command line:
    #    source ~/dotfiles_script/dotfiles.sh
    ```

4.  Reload bash.

#### Install as `git submodule`

1.  Create new repository:

    ```bash
    $ mkdir ~/.dotfiles
    $ cd ~/.dotfiles
    $ git init
    ```

2.  Add in your repository as submodule:

    ```bash
    $ git submodule add https://bitbucket.org/GentleFly/dotfiles
    ```

3.  In your `~/.bashrc`, define name of directory for yours dotfiles and add
    `dotfiles.sh` as source:

    ```bash
    # Define path for yours dotfiles:
    export DOTFILES_DIR="$HOME/.dotfiles"
    # Include bash script `dotfiles.sh`:
    if [[ -f ${DOTFILES_DIR}/dotfiles/dotfiles.sh ]] ; then
        source ${DOTFILES_DIR}/dotfiles/dotfiles.sh
    fi
    # for use once times, use this line in command line:
    #    source ~/dotfiles/dotfiles.sh
    ```

4.  Reload bash.

### Start to use

#### Include your files in "dotfiles"

Add, in dotfiles, your files (example):

```bash
$ ls -a ~/.dotfiles/home/
./  ../
$ ls -a ~/
./  ../  .bashrc  .vimrc
$ dotfiles include ~/.bashrc ~/.vimrc
```

Then, in directory `~/.dotfiles/home/` will moved this files:

```bash
$ ls -a ~/.dotfiles/home/
./  ../  .bashrc  .vimrc
```

And in `~/` directory will created symlink to this files:

```bash
$ ls -a ~/
./  ../  .bashrc@  .vimrc@
```

#### Exclude your files from "dotfiles"

For exclude yours file from "dotfiles" use command `dotfiles exclude`.
Then, in home (~/) directory will be deleted symlinks for this files, and 
in home (~/) directory will be moved this files from `$DOTFILES_DIR/home`.

```bash
$ ls -a ~/.dotfiles/home/
./  ../  .bashrc  .vimrc
$ ls -a ~/
./  ../  .bashrc@  .vimrc@
$ dotfiles exclude ~/.bashrc ~/.vimrc
$ ls -a ~/.dotfiles/home/
./  ../
$ ls -a ~/
./  ../  .bashrc  .vimrc
```

### Install your "dotfiles" on new machine. Example

#### if you use "dotfiles" separately

```bash
$ cp dotfiles_from_old_machine ~/.dotfiles/
$ git clone https://bitbucket.org/GentleFly/dotfiles ~/dotfiles_script
$ export DOTFILES_DIR="~/.dotfiles"
$ source ~/dotfiles_script/dotfiles.sh
$ dotfiles setup_all
```

#### if you use "dotfiles" as `git submodule`

```bash
$ git clone --recurse-submodules https://domen.org/yours_dotfiles ~/.dotfiles
$ export DOTFILES_DIR="~/.dotfiles"
$ source ~/.dotfiles/dotfiles/dotfiles.sh
$ dotfiles setup_all
```

## dotfiles help

```bash
$ dotfiles help
usage:

    dotfiles <command> [file]...

commands:

    include       - move files from "system dir" to "dotfiles dir" and create
                    symlinks in "system dir" to files in "dotfiles dir"
    reinclude     - force move files from "system dir" to "dotfiles dir" and
                    create symlinks in "system dir" to files in "dotfiles dir"
    exclude       - remove symlinks in "system dir" and move files from
                    "dotfiles dir" to "system dir"
    try_setup     - trying creating symlink in "system dir" for files
                    in "dotfiles dir", if exist file with name same as
                    potential symlink symlink, symlink will not created
    try_setup_all - same as command "try_setup", but for all files recursively
                    in "dotfiles dir"
    setup         - force creating symlink in "system dir" for files
                    in "dotfiles dir"
    setup_all     - same as command "setup", but for all files recursively
                    in "dotfiles dir"
    unsetup       - delete symlink in "system dir" for file in "dotfiles dir"
    unsetup_all   - same as command "unsetup", but for all files recursively
                    in "dotfiles dir"
    help          - print this massage

"system dir"   - this "~/"(home) or "/"(root) directories
"dotfiles dir" - this "~/.dotfilesrepo/home"(home dir in dotfiles dir) or
                 "~/.dotfilesrepo/root"(dir root in dotfiles dir) directories

Current dotfiles dir: /home/GentleFly/.dotfiles
```


## How use it in MSYS2

In file `msys2_shell.cmd` uncomment line:

```bat
set MSYS=winsymlinks:nativestrict
```

## Customize Local Settings

### Git

Create file `~/.gitconfig.local` and add in file `~/.gitconfig`:

```gitconfig
# Use separate file for username / github token / etc
[include]
    path = ~/.gitconfig.local
```

### Bash

Create file `~/.bashrc.local` and add in file `~/.bashrc`:

```bash
# Local customized path and environment settings, etc.
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
```

### Vim

You can add the following to the end of your .vimrc file to enable overriding:

```vimscript
let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
    source $LOCALFILE
endif
```

