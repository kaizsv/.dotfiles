#!/bin/bash

UNAME=$(uname -s)

if [ $UNAME == "Linux" ]; then

    PACS="vim git valgrind htop curl cloc tree tmux wget net-tools cscope stow
        cmake flex bison strace qemu tcl tk minicom autoconf vlc bash-completion
        nmap make trace-cmd okular evince graphviz gnuplot gcc thunderbird gdb
        audacious gnome-tweak-tool pcsc-tools libreoffice goldendict quiterss
        cppcheck solfege"
    DEBS="software-properties-common python3-pip exuberant-ctags python3-dev
        apt-transport-https autotools-dev qemu-utils libvirt-clients pcscd
        libvirt-daemon-system clang-format haskell-platform texlive-full
        build-essential gcc-arm-none-eabi gdb-multiarch"

    LSB_RELEASE=$(cat /etc/lsb-release | cut -d '=' -f 2)
    case $LSB_RELEASE in
        *Ubuntu*)
            sudo apt update
            sudo apt install -y $PACS $DEBS linux-tools-common \
                linux-tools-generic
            ;;
        *Debian*)
            sudo apt update
            sudo apt install -y $PACS $DEBS linux-tools linux-perf
            ;;
        *Arch*)
            sudo pacman --needed -Syu $PACS ctags libvirt clang texlive-most \
                atom base-devel xdg-desktop-portal xdg-desktop-portal-gtk \
                pipewire libpipewire02
            [ -d "$HOME/usr/yay" ] || \
                git clone https://aur.archlinux.org/yay.git $HOME/usr/yay
            ;;
        *)
            echo "Warn: Cannot read /etc/lsb-release" 1>&2
            exit 1
            ;;
    esac

    unset LSB_RELEASE
    unset PACS
    unset DEBS

    # vim-plug
    [ -f "$HOME/.vim/autoload/plug.vim" ] || \
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    mkdir -p $HOME/usr
    mkdir -p $HOME/tmp
    [ -d "$HOME/Templates" ] && touch ~/Templates/UntitiledDocument

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
