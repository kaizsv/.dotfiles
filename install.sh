#!/bin/bash

UNAME=$(uname -s)

if [ $UNAME == "Linux" ]; then

    PACS="vim git valgrind htop curl cloc tree tmux wget net-tools cscope stow
        cmake flex bison strace qemu tcl tk minicom autoconf vlc bash-completion
        nmap make trace-cmd okular evince graphviz gnuplot gcc thunderbird gdb
        audacious gnome-tweak-tool pcsc-tools emacs libreoffice"
    DEBS="software-properties-common python3-pip exuberant-ctags python3-dev
        apt-transport-https autotools-dev qemu-utils libvirt-clients pcscd
        libvirt-daemon-system clang-format haskell-platform texlive-full
        build-essential gcc-arm-none-eabi gdb-multiarch"

    if [[ "$(lsb_release -d)" == *"Ubuntu"* ]]; then
        sudo apt update
        sudo apt install -y $PACS $DEBS linux-tools-common linux-tools-generic
    elif [[ "$(lsb_release -d)" == *"Debian"* ]]; then
        sudo apt update
        sudo apt install -y $PACS $DEBS linux-tools linux-perf
    elif [ -f "/etc/arch-release" ]; then
        sudo pacman -Syu $PACS ctags libvirt clang texlive-most atom
    fi

    unset PACS
    unset DEBS

    # vim-plug
    [ -f "$HOME/.vim/autoload/plug.vim" ] || \
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    mkdir -p $HOME/usr
    mkdir -p $HOME/tmp
    [ -d "$HOME/Templates" ] && touch ~/Templates/UntitiledDocument

    # cron job: * * * * * export DISPLAY=:0; /usr/bin/quiterss
    [ -d "$HOME/usr/quiterss" ] || \
        git clone https://github.com/QuiteRSS/quiterss.git ~/usr/quiterss
    [ -d "$HOME/usr/goldendict" ] || \
        git clone https://github.com/goldendict/goldendict.git ~/usr/goldendict

    # install dotfiles
    if [ -x "$(command -v stow)" ]; then
        HOME_SYMLINKS=$(find $HOME -maxdepth 1 -type l)
        for target in gdb git vim tmux bash
        do
            [[ "$HOME_SYMLINKS" == *"$target"* ]] || \
                stow --dotfiles $target -t $HOME
        done
        unset HOME_SYMLINKS
    else
        echo "Warn: No stow. Please install stow!" 1>&2
        exit 1
    fi

fi

unset UNAME
