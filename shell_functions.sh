#!/bin/bash
mkcd(){
    mkdir -p "$1" && cd "$1"
}
sharedir(){
    pwd > $HOME/.sharedir
}
sharecd(){
    if [ $(sharecat | wc -l) -gt 0 ]; then
        cd $(cat $HOME/.sharedir | head -1)
    else
        echo "No directory shared"
    fi
}
sharecat(){
    cat $HOME/.sharedir
}
sharepush(){
    echo $(pwd) | cat - $HOME/.sharedir > $HOME/.sharetmp && mv $HOME/.sharetmp $HOME/.sharedir
}
sharepop(){
    sharecd
    file_len=`expr $(sharecat | wc -l) - 1`
    if [ $file_len -gt 0 ]; then
        sharecat | head -$(expr $(sharecat | wc -l) - 1) > $HOME/.sharedir;
    else
        rm -f $HOME/.sharedir
        touch $HOME/.sharedir
    fi
}

# MacOS specific
killdock(){
    defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock
}

lookfor(){
    find "$2" -name "$1" -print
}
