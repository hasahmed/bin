#!/bin/bash
mkcd(){
    mkdir -p "$1" && cd "$1"
}
sharedir(){
    pwd > $HOME/.sharedir
}
sharecd(){
    if [ $(catshare | wc -l) -gt 0 ]; then
        cd $(cat $HOME/.sharedir | tail -1)
    else
        echo "No directory shared"
    fi
}
sharecat(){
    cat $HOME/.sharedir
}
sharepush(){
    pwd >> $HOME/.sharedir
}
sharepop(){
    cdshare
    file_len=`expr $(catshare | wc -l) - 1`
    if [ $file_len -gt 0 ]; then
        catshare | head -$(expr $(catshare | wc -l) - 1) > $HOME/.sharedir;
    else
        rm -f $HOME/.sharedir
        touch $HOME/.sharedir
    fi
}

killdock(){
    defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock
}
