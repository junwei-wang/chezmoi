function update -d "System update"
    if type -q brew
        echo "Updating Homebrew"
        brew update
        brew upgrade
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


    if test -d ~/github/org
        echo "Pulling latest org repository from GitHub"
        cd ~/github/org
        git pull
    else
        echo "Cloning github/junwei-wang:org"
        mkdir -p ~/github
        git clone git@github.com:junwei-wang/org.git ~/github/org
    end

    if type -q doom
        echo "Updating doom"
        doom upgrade
    end
end
