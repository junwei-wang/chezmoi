function update -d "System update"
    if type -q brew
        echo "Updating Homebrew"
        brew update
        brew upgrade
        brew cleanup
    else if type -q pacman
        echo "Update pacman"
        sudo pacman -Syu
        echo "Clean pacman"
        sudo pacman -R (pacman -Qtdq)
    end

    echo ""

    if type -q doom
        echo "Updating doom"
        doom upgrade
        doom purge
    end

    if test -d ~/.cb/cryptobib
        echo "Pulling latest cryptobib"
        cd ~/.cb/cryptobib
        git pull
    else
        echo "Cloning cryptobib"
        mkdir -p ~/.cb
        git clone https://github.com/cryptobib/export ~/.cb/cryptobib
    end
    echo ""


    if test -d ~/github/org
        echo "Pulling latest org repository from GitHub"
        cd ~/github/org
        git pull
        if git diff-index --quiet HEAD
            echo Clean
        else
            echo "WARNING: Need to commit org"
        end
    else
        echo "Cloning github/junwei-wang:org"
        mkdir -p ~/github
        git clone git@github.com:junwei-wang/org.git ~/github/org
    end
    echo ""

end
