function aur -d "Install AUR Package"
    git clone https://aur.archlinux.org/$argv.git $HOME/aur/$argv
    cd $HOME/aur/$argv
    makepkg -sri
    cd -
end
