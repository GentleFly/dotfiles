#!/bin/bash

# TODO: backup ???? after function exclude

_dotfiles_dir="${DOTFILES_DIR:="~/.dotfiles"}"

_dotfiles_home_dir=$(realpath  "${_dotfiles_dir}"/home/)
_dotfiles_root_dir=$(realpath  "${_dotfiles_dir}"/root/)
_dotfiles_backup_dir=$(realpath  "${_dotfiles_dir}"/backup/)
_dotfiles_sys_home_dir=~/
_dotfiles_sys_root_dir=/

_dotfiles_commands_inc="include reinclude exclude"
_dotfiles_commands_set="setup try_setup try_setup_all unsetup unsetup_all list"
_dotfiles_commands_help="help"
_dotfiles_commands="${_dotfiles_commands_inc} ${_dotfiles_commands_set} ${_dotfiles_commands_help}"

function _dotfiles_export_colors() { #{{{
# Reference: https://wiki.archlinux.org/index.php/Bash/Prompt_customization_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9)

	# Сброс
	Color_Off='\e[0m'       # Text Reset

	# Обычные цвета
	Black='\e[0;30m'        # Black
	Red='\e[0;31m'          # Red
	Green='\e[0;32m'        # Green
	Yellow='\e[0;33m'       # Yellow
	Blue='\e[0;34m'         # Blue
	Purple='\e[0;35m'       # Purple
	Cyan='\e[0;36m'         # Cyan
	White='\e[0;37m'        # White

	# Жирные
	BBlack='\e[1;30m'       # Black
	BRed='\e[1;31m'         # Red
	BGreen='\e[1;32m'       # Green
	BYellow='\e[1;33m'      # Yellow
	BBlue='\e[1;34m'        # Blue
	BPurple='\e[1;35m'      # Purple
	BCyan='\e[1;36m'        # Cyan
	BWhite='\e[1;37m'       # White

	# # Подчёркнутые
	# UBlack='\e[4;30m'       # Black
	# URed='\e[4;31m'         # Red
	# UGreen='\e[4;32m'       # Green
	# UYellow='\e[4;33m'      # Yellow
	# UBlue='\e[4;34m'        # Blue
	# UPurple='\e[4;35m'      # Purple
	# UCyan='\e[4;36m'        # Cyan
	# UWhite='\e[4;37m'       # White

	# # Фоновые
	# On_Black='\e[40m'       # Black
	# On_Red='\e[41m'         # Red
	# On_Green='\e[42m'       # Green
	# On_Yellow='\e[43m'      # Yellow
	# On_Blue='\e[44m'        # Blue
	# On_Purple='\e[45m'      # Purple
	# On_Cyan='\e[46m'        # Cyan
	# On_White='\e[47m'       # White

	# # Высоко Интенсивные
	# IBlack='\e[0;90m'       # Black
	# IRed='\e[0;91m'         # Red
	# IGreen='\e[0;92m'       # Green
	# IYellow='\e[0;93m'      # Yellow
	# IBlue='\e[0;94m'        # Blue
	# IPurple='\e[0;95m'      # Purple
	# ICyan='\e[0;96m'        # Cyan
	# IWhite='\e[0;97m'       # White

	# # Жирные Высоко Интенсивные
	# BIBlack='\e[1;90m'      # Black
	# BIRed='\e[1;91m'        # Red
	# BIGreen='\e[1;92m'      # Green
	# BIYellow='\e[1;93m'     # Yellow
	# BIBlue='\e[1;94m'       # Blue
	# BIPurple='\e[1;95m'     # Purple
	# BICyan='\e[1;96m'       # Cyan
	# BIWhite='\e[1;97m'      # White

	# # Высоко Интенсивные фоновые
	# On_IBlack='\e[0;100m'   # Black
	# On_IRed='\e[0;101m'     # Red
	# On_IGreen='\e[0;102m'   # Green
	# On_IYellow='\e[0;103m'  # Yellow
	# On_IBlue='\e[0;104m'    # Blue
	# On_IPurple='\e[0;105m'  # Purple
	# On_ICyan='\e[0;106m'    # Cyan
	# On_IWhite='\e[0;107m'   # White
} #}}}

_dotfiles_convert_path_dotfile_to_system_for_file() { #{{{
    # _dotfiles_convert_path_dotfile_to_system_for_file home/.vimrc
    # _dotfiles_convert_path_dotfile_to_system_for_file root/bob.file

    local target_file=""
    local source_file=$(realpath ${1})

    if   [[ "${source_file}" == *"${_dotfiles_home_dir}"* ]]; then
        target_file=$(echo "${source_file}" | sed "s|${_dotfiles_home_dir}/|${_dotfiles_sys_home_dir}|")
    elif [[ "${source_file}" == *"${_dotfiles_root_dir}"* ]]; then
        target_file=$(echo "${source_file}" | sed "s|${_dotfiles_root_dir}/|${_dotfiles_sys_root_dir}|")
    else
        echo "_dotfiles_convert_path_dotfile_to_system_for_file: Error: file not located in home or root in dotfiles!"
        return 1
    fi

    target_file=$(realpath -s ${target_file})
    echo ${target_file}
    return 0
} #}}}

_dotfiles_convert_path_system_to_dotfile_for_file() { #{{{
    # _dotfiles_convert_path_system_to_dotfile_for_file ~/.vimrc
    # _dotfiles_convert_path_system_to_dotfile_for_file /bob.file

    local target_file=""
    local source_file=$(realpath -s ${1})

    if   [[ "${source_file}" == *"${_dotfiles_home_dir}"* ]]; then
        echo "_dotfiles_convert_path_system_to_dotfile_for_file: Error: file located in home dir in dotfiles!"
        return 1
    elif [[ "${source_file}" == *"${_dotfiles_root_dir}"* ]]; then
        echo "_dotfiles_convert_path_system_to_dotfile_for_file: Error file located in root dir in dotfiles!"
        return 2
    elif   [[ "${source_file}" == *"${_dotfiles_sys_home_dir}"* ]]; then
        target_file=$(echo "${source_file}" | sed "s|${_dotfiles_sys_home_dir}|${_dotfiles_home_dir}/|")
    elif [[ "${source_file}" == *"${_dotfiles_sys_root_dir}"* ]]; then
        target_file="${_dotfiles_root_dir}${source_file}"
    else
        echo "_dotfiles_convert_path_system_to_dotfile_for_file: Error!"
        return 3
    fi

    #target_file=$(realpath -s ${target_file})
    echo ${target_file}
    return 0
} #}}}

_dotfiles_check_access() { #{{{
    ln -sf ${1} teset_access
    if [ $? -eq 0 ]; then
        rm teset_access # OK
        return 0
    else
        return 1
    fi
} #}}}

_dotfiles_backup() { #{{{
    if [ $# -ne 1 ]
    then
        echo "_dotfiles_backup: Error: bad parameters"
        return 1
    fi

    local l_backup_file=$(realpath ${1})

    if ! [ -f ${l_backup_file} ] ; then
        echo "_dotfiles_backup: Error: file for backup not found!?"
        echo -e "\t${l_backup_file}"
        return 3
    fi

    #echo "${l_backup_file}"
    #echo "${_dotfiles_backup_dir}${l_backup_file}"
    if ! [ -d $(dirname  "${_dotfiles_backup_dir}${l_backup_file}") ] ; then
        mkdir -p $(dirname  "${_dotfiles_backup_dir}${l_backup_file}")
        if [ $? -ne 0 ] ; then
            return 4
        fi
    fi

    cp -f "${l_backup_file}" "${_dotfiles_backup_dir}${l_backup_file}"
    if [ $? -ne 0 ] ; then
        return 5
    fi
    echo -e "file \"${l_backup_file}\" was copied to \"${_dotfiles_backup_dir}${l_backup_file}\""

    return 0
} #}}}


_dotfiles_setup_file() { #{{{
    # use:
    # $ _dotfiles_setup_file ./home/home_dotfiles.test
    # $ _dotfiles_setup_file ./root/root_dotfiles.test
    # $ func_name src_file_from_dotfiles
    local source_file=$(realpath ${1})
    local target_file=$(_dotfiles_convert_path_dotfile_to_system_for_file "${source_file}")
    if [ $? -ne 0 ]; then
        # TODO: ???
        return 2
    fi

    if ! [ -d $(dirname ${target_file}) ]; then
        echo "WARNING: dir $(dirname ${target_file}) is not exist!"
        mkdir -p $(dirname ${target_file})
        echo "dir $(dirname ${target_file}) was created!"
    fi

    ln -sf ${source_file} ${target_file}
    if [ $? -eq 0 ]; then
        echo "created symlink: \"${target_file}\" -> \"${source_file}\" "
    else
        echo "Error: symlink was not created: \"${target_file}\" -> \"${source_file}\" "
        return 1
    fi

    return 0
} #}}}

_dotfiles_setup() { #{{{

    _dotfiles_check_access $0
    if [ $? -ne 0 ]; then
        echo ERROR:
        echo -e "\tIn MSYS2, run shell as Admin!"
        echo -e "\tIn Linux, use sudo!"
        return 1
    fi

    if [ $# == 0 ] ; then
        if [ -d ${_dotfiles_home_dir} ] ; then
            for source_file in $(find ${_dotfiles_home_dir} -type f)
            do
                _dotfiles_setup_file ${source_file}
            done
        fi
        if [ -d ${_dotfiles_root_dir} ] ; then
            for source_file in $(find ${_dotfiles_root_dir} -type f)
            do
                _dotfiles_setup_file ${source_file}
            done
        fi
    else
        for source_file in ${*} ; do
            # TODO: check after creating function "exclude"
            local target_file=$(_dotfiles_convert_path_dotfile_to_system_for_file "${source_file}")
            if [ $? -ne 0 ]; then
                # TODO: ???
                return 2
            fi
            if ! [ -L ${target_file} ] && [ -f ${target_file} ] ; then
                _dotfiles_backup ${target_file}
            fi
            _dotfiles_setup_file ${source_file}
        done
    fi

    return 0
} #}}}

_dotfiles_try_setup_file() { #{{{
    # use:
    # $ _dotfiles_try_setup_file ./home/home_dotfiles.test
    # $ _dotfiles_try_setup_file ./root/root_dotfiles.test
    # $ func_name src_file_from_dotfiles
    local source_file=$(realpath ${1})
    local target_file=$(_dotfiles_convert_path_dotfile_to_system_for_file "${source_file}")
    if [ $? -ne 0 ]; then
        # TODO: ???
        return 2
    fi

    if ! [ -d $(dirname ${target_file}) ]; then
        echo "WARNING: dir $(dirname ${target_file}) is not exist!"
        mkdir -p $(dirname ${target_file})
        echo "dir $(dirname ${target_file}) was created!"
    fi

    ln -s ${source_file} ${target_file}
    if [ $? -eq 0 ]; then
        echo "symlink was created: ${source_file} "
    else
        echo "Error: symlink was not created: ${source_file} "
        return 1
    fi

    return 0
} #}}}

_dotfiles_try_setup() { #{{{

    if [ $# == 0 ] ; then
        #_dotfiles_help
        echo "_dotfiles_try_setup: error: files not find!"
        echo " use: dotfiles try_setup {dotfilerepo/file}"
        return 1
    fi

    for source_file in ${*}
    do
        _dotfiles_try_setup_file ${source_file}
    done

    return 0
} #}}}

_dotfiles_try_setup_all() { #{{{

    _dotfiles_check_access $0
    if [ $? -ne 0 ]; then
        echo ERROR:
        echo -e "\tIn MSYS2, run shell as Admin!"
        echo -e "\tIn Linux, use sudo!"
        return 1
    fi

    if [ -d ${_dotfiles_home_dir} ] ; then
        for source_file in $(find ${_dotfiles_home_dir} -type f)
        do
            _dotfiles_try_setup_file ${source_file}
        done
    fi
    if [ -d ${_dotfiles_root_dir} ] ; then
        for source_file in $(find ${_dotfiles_root_dir} -type f)
        do
            _dotfiles_try_setup_file ${source_file}
        done
    fi

    return 0
} #}}}


_dotfiles_unsetup_file() { #{{{
    # use:
    # $ _dotfiles_unsetup_file ./home/home_dotfiles.test
    # $ _dotfiles_unsetup_file ./root/root_dotfiles.test
    # $ func_name src_file_from_dotfiles
    local source_file=$(realpath ${1})
    if ! [ -f ${source_file} ]; then
        echo "_dotfiles_unsetup_file: Error: \"${source_file}\" not exist!"
        return 1
    fi

    local target_file=$(_dotfiles_convert_path_dotfile_to_system_for_file "${source_file}")
    if [ $? -ne 0 ]; then
        echo "_dotfiles_unsetup_file: Error: _dotfiles_convert_path_dotfile_to_system_for_file"
        return 2
    fi

    if ! [ -L ${target_file} ]; then
        echo "_dotfiles_unsetup_file: Error: symlink \"${target_file}\" not exist!"
        return 3
    fi

    # TODO: exclude ???
    # maby onli delete symlink?
    #cp --remove-destination ${source_file} ${target_file}
    rm ${target_file}
    if [ $? -eq 0 ]; then
        #echo -e "symlink \"${target_file}\" was replaced file \"${source_file}\""
        echo -e "symlink \"${target_file}\" was removed"
    fi
    return 0
} #}}}

_dotfiles_unsetup() { #{{{

    if [ $# == 0 ] ; then
        #_dotfiles_help
        echo "_dotfiles_unsetup: error: files not find!"
        echo " use: dotfiles unsetup {dotfilerepo/file}"
        return 1
    fi

    for source_file in ${*}
    do
        _dotfiles_unsetup_file ${source_file}
    done

    return 0
} #}}}

_dotfiles_unsetup_all() { #{{{

    _dotfiles_check_access $0
    if [ $? -ne 0 ]; then
        echo ERROR:
        echo -e "\tIn MSYS2, run shell as Admin!"
        echo -e "\tIn Linux, use sudo!"
        return 1
    fi

    # TODO: check dir exist ???
    for source_file in $(find ${_dotfiles_home_dir} -type f)
    do
        _dotfiles_unsetup_file ${source_file}
    done
    # TODO: check dir exist ???
    for source_file in $(find ${_dotfiles_root_dir} -type f)
    do
        _dotfiles_unsetup_file ${source_file}
    done

    return 0
} #}}}


_dotfiles_include_file() { #{{{
    # use:
    # $ _dotfiles_include_file ~/home_dotfiles.test
    # $ _dotfiles_include_file /root_dotfiles.test
    # $ func_name src_file_from_sysfiles

    # TODO: realpath -s
    if [[ -L ${1} ]] ; then
        echo "_dotfiles_include_file: Error: file \"${1}\" is symlink!"
        return 1
    fi
    local source_file=$(realpath -s ${1})
    local target_file=$(_dotfiles_convert_path_system_to_dotfile_for_file "${source_file}")
    if [[ $? -ne 0 ]] ; then
        return 1
    fi

    if ! [[ -d $(dirname ${target_file}) ]]; then
        mkdir -p $(dirname ${target_file})
    fi

    if [[ -f ${target_file} ]] ; then
        echo "_dotfiles_include_file: Error: file \"${target_file}\" is exist!"
        return 2
    fi

    cp "${source_file}" "${target_file}"

    if [ $? -eq 0 ]; then
        echo -e "file \"${source_file}\" was copied to \"${target_file}\""
    else
        echo "Error: file was not copied: ${source_file} "
        return 3
    fi

    _dotfiles_setup_file ${target_file}

    return 0
} #}}}

_dotfiles_include() { #{{{

    _dotfiles_check_access $0
    if [ $? -ne 0 ] ; then
        echo ERROR:
        echo -e "\tIn MSYS2, run shell as Admin!"
        echo -e "\tIn Linux, use sudo!"
        return 1
    fi

    if [ $# == 0 ] ; then
        #_dotfiles_help
        echo "_dotfiles_include: error: arguments for files not find!"
        echo " use: dotfiles include {sysfile/file}"
        return 1
    fi

    for source_file in ${*}
    do
        _dotfiles_include_file ${source_file}
    done

    return 0
} #}}}

_dotfiles_reinclude_file() { #{{{

    if [ $# == 0 ] ; then
        #_dotfiles_help
        echo "_dotfiles_reinclude_file: error: arguments for files not find!"
        echo " use: dotfiles include {sysfile/file}"
        return 1
    fi

    for source_file in ${*}
    do
        local target_file=$(_dotfiles_convert_path_system_to_dotfile_for_file "${source_file}")
        if [[ $? -ne 0 ]] ; then
            return 1
        fi
        rm -f ${target_file}
        if [[ $? -ne 0 ]] ; then
            echo "_dotfiles_reinclude_file: Error: can not delete file \"${target_file}\"!"
            return 1
        fi
        echo "file has been deleted: \"${target_file}\""
        _dotfiles_include_file ${source_file}
    done

    return 0
} #}}}

_dotfiles_reinclude() { #{{{
    _dotfiles_check_access $0
    if [ $? -ne 0 ] ; then
        echo ERROR:
        echo -e "\tIn MSYS2, run shell as Admin!"
        echo -e "\tIn Linux, use sudo!"
        return 1
    fi

    if [ $# == 0 ] ; then
        #_dotfiles_help
        echo "_dotfiles_reinclude: error: arguments for files not find!"
        echo " use: dotfiles include {sysfile/file}"
        return 1
    fi

    for source_file in ${*}
    do
        _dotfiles_reinclude_file ${source_file}
    done

    return 0
} #}}}

_dotfiles_exclude_file() { #{{{
    # use:
    # $ _dotfiles_exclude ./home/home_dotfiles.test
    # $ _dotfiles_exclude ./root/root_dotfiles.test
    # $ func_name src_file_from_dotfiles
    local source_file=$(realpath ${1})
    if ! [ -f ${source_file} ]; then
        echo "_dotfiles_exclude: Error: \"${source_file}\" not exist!"
        return 1
    fi

    local target_file=$(_dotfiles_convert_path_dotfile_to_system_for_file "${source_file}")
    if [ $? -ne 0 ]; then
        echo "_dotfiles_exclude: Error: _dotfiles_convert_path_dotfile_to_system_for_file"
        return 2
    fi

    if ! [ -L ${target_file} ]; then
        echo "_dotfiles_exclude: Error: symlink \"${target_file}\" not exist!"
        return 3
    fi

    cp --remove-destination ${source_file} ${target_file}
    if [ $? -eq 0 ]; then
        echo -e "symlink \"${target_file}\" was replaced file \"${source_file}\""
    fi
    rm ${source_file}
    if [ $? -eq 0 ]; then
        echo -e "file \"${source_file}\" deleted!"
    fi
    return 0
} #}}}

_dotfiles_exclude() { #{{{

    if [ $# == 0 ] ; then
        #_dotfiles_help
        echo "_dotfiles_exclude: error: files not find!"
        echo " use: dotfiles exclude {dotfilerepo/file}"
        return 1
    fi

    for source_file in ${*}
    do
        _dotfiles_exclude_file ${source_file}
    done

    return 0
} #}}}

_dotfiles_check_installed() { #{{{
    if [ $# -ne 1 ] ; then
        return 1
    fi

    local source_file=$1
    local symlink=$(_dotfiles_convert_path_dotfile_to_system_for_file "${source_file}")
    echo -n "${source_file} <- "
    if [ -L ${symlink} ]; then
        echo -e "${Green}${symlink}${Color_Off}"
    else
        echo -e "${BRed}file not setup ${Red}(symlink not exist)!${Color_Off}"
    fi

    return 0
} #}}}

_dotfiles_list() { #{{{

    if [ $# == 0 ] ; then
        if [ -d ${_dotfiles_home_dir} ] ; then
            for source_file in $(find ${_dotfiles_home_dir} -type f)
            do
                _dotfiles_check_installed ${source_file}
            done
        fi
        if [ -d ${_dotfiles_root_dir} ] ; then
            for source_file in $(find ${_dotfiles_root_dir} -type f)
            do
                _dotfiles_check_installed ${source_file}
            done
        fi
    else
        while ((${#})); do
            if [ -f ${1} ] ; then
                _dotfiles_check_installed ${1}
            else
                echo -e "${1} ${BRed}file not exist or not setup"
            fi
            shift
        done
    fi

    return 0
} #}}}

_dotfiles_help() {  #{{{
    echo "usage:"
    echo ""
    echo "    dotfiles <command> [file]..."
    echo ""
    echo "commands:"
    echo ""
    echo "    include       - move files from \"system dir\" to \"dotfiles dir\" and create"
    echo "                    symlinks in \"system dir\" to files in \"dotfiles dir\""
    echo "    reinclude     - force move files from \"system dir\" to \"dotfiles dir\" and"
    echo "                    create symlinks in \"system dir\" to files in \"dotfiles dir\""
    echo "    exclude       - remove symlinks in \"system dir\" and move files from"
    echo "                    \"dotfiles dir\" to \"system dir\""
    echo "    try_setup     - trying creating symlink in \"system dir\" for files"
    echo "                    in \"dotfiles dir\", if exist file with name same as"
    echo "                    potential symlink symlink, symlink will not created"
    echo "    try_setup_all - same as command \"try_setup\", but for all files recursively"
    echo "                    in \"dotfiles dir\""
    echo "    setup [files] - force creating symlink in \"system dir\" for files"
    echo "                    in \"dotfiles dir\""
    echo "    setup         - same as command \"setup\", but for all files recursively"
    echo "                    in \"dotfiles dir\""
    echo "    unsetup       - delete symlink in \"system dir\" for file in \"dotfiles dir\""
    echo "    unsetup_all   - same as command \"unsetup\", but for all files recursively"
    echo "                    in \"dotfiles dir\""
    echo "    help          - print this massage"
    echo ""
    echo "\"system dir\"   - this \"~/\"(home) or \"/\"(root) directories"
    echo "\"dotfiles dir\" - this \"~/.dotfilesrepo/home\"(home dir in dotfiles dir) or"
    echo "                 \"~/.dotfilesrepo/root\"(dir root in dotfiles dir) directories"
    echo ""
    echo "Current dotfiles dir: $(realpath  "${_dotfiles_dir}"/)"
    echo ""
#   echo "You may need administrator rights"
#   echo "================================================================================"

    return 0
} #}}}

# TODO:
# source lib.sh
dotfiles() { #{{{

	_dotfiles_export_colors

    if [ $# == 0 ] ; then
        _dotfiles_help
        return 1
    fi

    local command_input=""
    for valid_command in ${_dotfiles_commands[@]} ; do
        if [[ "${1}" == "${valid_command}" ]] ; then
            command_input="_dotfiles_${1}"
        fi
    done
    if [[ "${command_input}" == "" ]] ; then
        echo -e "dotfiles: error: command \"${1}\" not exist!"
        _dotfiles_help
        return 1
    fi
    shift

    ${command_input} ${*}

    #shift
    #echo ${*}
    #echo ${#}

    #for argument in ${*} ; do
    #    echo "arg: ${argument}"
    #done



    return 0

    echo "command:     dotfiles"
    echo "sub command:" "${1}"
    echo -n "files:      "

    local argc=$#
    local argv=($@)

    for (( j=1; j<argc; j++ )); do
        echo -n " ${argv[j]}"
    done
    echo -e "\n$@"
    shift
    echo -e "\n$@"

    return 0
} #}}}


# based on _longopt. For get surce this functions:
#	$ type _longopt
_dotfiles_completion() { #{{{
    local cur prev words cword split;
    _init_completion -s || return;
    #echo -e "\ncur:${cur}; prev:${prev}; words:${words}; cword:${cword}; split:${split}\n"

    case "${cword}" in
        1)
            COMPREPLY=( $(compgen -W "${_dotfiles_commands}" -- "${cur}") )
            return;
        ;;
        2)
            if [[ "${_dotfiles_commands_inc} ${_dotfiles_commands_set}" == *"${prev}"* ]]; then
                _filedir;
            else
                return;
            fi;
        ;;
        *)
            _filedir;
        ;;
    esac;
} #}}}
complete -F _dotfiles_completion dotfiles

# vim:set foldmethod=marker:
