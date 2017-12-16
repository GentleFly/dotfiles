
# .DotFiles

## Description

In this repository, DotFiles is several bash commands (scripts) for management
of user's dotfiles (example `~/.vimrc`, `~/.bashrc` and another), based on
symlinks. This commands have bash auto completion. For getting help use
command `dotfiles help`.

**WARNING:** backup your files :) I need help for test it.

## Main idea of management of user's dotfiles, based on symlinks

 *  A `~/.dotfiles/home` directory that contains all of the dotfiles themselves.
    These are all managed in a git repo.

    ```bash
    $ ls -l ~/.dotfiles/home/.bashrc ~/.dotfiles/home/.vimrc
    -rw-r--r-- 1 user Отсутствует 8.5K Dec 11 22:52 /home/user/.dotfiles/home/.bashrc
    -rw-r--r-- 1 user Отсутствует  12K Nov 30 19:41 /home/user/.dotfiles/home/.vimrc
    ```

 *  A script, also in `~/.dotfiles/home` that creates the required links into my
    home directory. I don't have any dotfiles in my home directory, only links
    into `~/.dotfiles/home`. For example:

    ```bash
    $ ls -l ~/.bashrc ~/.vimrc
    lrwxrwxrwx 1 user Отсутствует 38 Dec 13 19:30 /home/user/.bashrc -> /home/user/.dotfiles/home/.bashrc
    lrwxrwxrwx 1 user Отсутствует 37 Dec 13 19:31 /home/user/.vimrc -> /home/user/.dotfiles/home/.vimrc
    ```

## Install

1.  Make directory for your dotfiles. Example:

    ```bash
    $ mkdir ~/.dotfiles
    ```

2.  Clone this repository to local directory (example: `~/dotfiles_script`,
    or another)

    ```bash
    $ git clone https://github.com/GentleFly/dotfiles ~/dotfiles_script
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

## Include your files in "dotfiles"

For adding, in dotfiles your files, use command `dotfiles include` (example):

```bash
$ ls -l ~/.bashrc ~/.vimrc
-rw-r--r-- 1 user Отсутствует 8.5K Dec 15 07:42 /home/user/.bashrc
-rw-r--r-- 1 user Отсутствует  12K Dec 15 07:42 /home/user/.vimrc

$ ls -l ~/.dotfiles/home/.bashrc ~/.dotfiles/home/.vimrc
ls: cannot access '/home/user/.dotfiles/home/.bashrc': No such file or directory
ls: cannot access '/home/user/.dotfiles/home/.vimrc': No such file or directory

$ dotfiles include ~/.bashrc ~/.vimrc
file "/home/user/.bashrc" was copied to "/home/user/.dotfiles/home/.bashrc"
symlink was created: /home/user/.dotfiles/home/.bashrc
file "/home/user/.vimrc" was copied to "/home/user/.dotfiles/home/.vimrc"
symlink was created: /home/user/.dotfiles/home/.vimrc
```

Then, in directory `~/.dotfiles/home/` will moved this files:

```bash
$ ls -l ~/.dotfiles/home/.bashrc ~/.dotfiles/home/.vimrc
-rw-r--r-- 1 user Отсутствует 8.5K Dec 15 07:46 /home/user/.dotfiles/home/.bashrc
-rw-r--r-- 1 user Отсутствует  12K Dec 15 07:46 /home/user/.dotfiles/home/.vimrc
```

And in `~/` directory will created symlink to this files:

```bash
$ ls -l ~/.bashrc ~/.vimrc
lrwxrwxrwx 1 user Отсутствует 38 Dec 15 07:46 /home/user/.bashrc -> /home/user/.dotfiles/home/.bashrc
lrwxrwxrwx 1 user Отсутствует 37 Dec 15 07:46 /home/user/.vimrc -> /home/user/.dotfiles/home/.vimrc
```

## Exclude your files from "dotfiles"

For exclude yours file from "dotfiles" use command `dotfiles exclude`.
Then, in home (~/) directory will be deleted symlinks for this files, and 
in home (~/) directory will be moved this files from `$DOTFILES_DIR/home`.

```bash
$ dotfiles exclude ~/.bashrc ~/.vimrc
symlink "/home/user/.bashrc" was replaced file "/home/user/.dotfiles/home/.bashrc"
file "/home/user/.dotfiles/home/.bashrc" deleted!
symlink "/home/user/.vimrc" was replaced file "/home/user/.dotfiles/home/.vimrc"
file "/home/user/.dotfiles/home/.vimrc" deleted!

$ ls -l ~/.dotfiles/home/.bashrc ~/.dotfiles/home/.vimrc
ls: cannot access '/home/user/.dotfiles/home/.bashrc': No such file or directory
ls: cannot access '/home/user/.dotfiles/home/.vimrc': No such file or directory

$ ls -l ~/.bashrc ~/.vimrc
-rw-r--r-- 1 user Отсутствует 8.5K Dec 15 07:52 /home/user/.bashrc
-rw-r--r-- 1 user Отсутствует  12K Dec 15 07:52 /home/user/.vimrc
```

## Install your "dotfiles" on new machine. Example

```bash
$ git clone https://bitbucket.org/YourUserName/YourDotFiles ~/.dotfiles
$ git clone https://github.com/GentleFly/dotfiles ~/dotfiles_script
$ export DOTFILES_DIR="~/.dotfiles"
$ source ~/dotfiles_script/dotfiles.sh
$ dotfiles setup
created symlink: "/home/user/.bashrc" -> "/home/user/.dotfiles/home/.bashrc"
created symlink: "/home/user/.config/mc/filehighlight.ini" -> "/home/user/.dotfiles/home/.config/mc/filehighlight.ini"
created symlink: "/home/user/.config/mc/mc.ext" -> "/home/user/.dotfiles/home/.config/mc/mc.ext"
created symlink: "/home/user/.dircolors" -> "/home/user/.dotfiles/home/.dircolors"
created symlink: "/home/user/.gitconfig" -> "/home/user/.dotfiles/home/.gitconfig"
created symlink: "/home/user/.inputrc" -> "/home/user/.dotfiles/home/.inputrc"
created symlink: "/home/user/.local/share/mc/skins/solarized.ini" -> "/home/user/.dotfiles/home/.local/share/mc/skins/solarized.ini"
created symlink: "/home/user/.minttyrc" -> "/home/user/.dotfiles/home/.minttyrc"
created symlink: "/home/user/.vimrc" -> "/home/user/.dotfiles/home/.vimrc"
```

## dotfiles help

```bash
$ dotfiles help
usage:

    dotfiles <command> [file]...

commands:

    include   - Move files from "system dir" to "dotfiles dir" and create
                symlinks in "system dir" to files in "dotfiles dir".
    reinclude - Force move files from "system dir" to "dotfiles dir" and
                create symlinks in "system dir" to files in "dotfiles dir".
    exclude   - Remove symlinks in "system dir" and move files from
                "dotfiles dir" to "system dir".
    setup     - Trying creating symlink in "system dir" for files
                in "dotfiles dir", if exist file with name same as potential
                symlink, symlink will not created.
              - This command without arguments [files] will be applied to all
                files recursively in "dotfiles dir".
    fsetup    - Force creating symlink in "system dir" for files
                in "dotfiles dir".
              - This command without arguments [files] will be applied to all
                files recursively in "dotfiles dir".
    unsetup   - Delete symlink in "system dir" for file in "dotfiles dir".
              - This command without arguments [files] will be applied to all
                files recursively in "dotfiles dir".
    help      - print this massage

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

