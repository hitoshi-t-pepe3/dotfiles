# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# export TERM=xterm-256color
# export TERM=screen-256color
# End of lines configured by zsh-newuser-install

# rbenv
if [ -d $HOME/.rbenv/bin ]; then
  export PATH="$PATH:$HOME/.rbenv/bin"
  eval "$(rbenv init - zsh)"
fi

# phpenv
if [ -d $HOME/.phpenv/bin ]; then
  export PATH="$PATH:$HOME/.rbenv/bin:$HOME/.phpenv/bin"
  eval "$(phpenv init - zsh)"
fi

# pyenv
eval "$(pyenv init - zsh)"
eval "$(pyenv virtualenv-init - zsh)"

# PS1='${debian_chroot:+($debian_chroot)}[\t] \$ '
PROMPT='[%n@%m]# '
RPROMPT='[%d]'

# google で検索できる
function google() {
   local str opt
   if [ $# != 0 ]; then
       for i in $*; do
           str="$str+$i"
       done
       str=`echo $str | sed 's/^\+//'`
       opt='search?num=50&hl=ja&lr=lang_ja'
       opt="${opt}&q=${str}"
    fi
    w3m -O utf8 http://www.google.co.jp/$opt
}

# w3m でpdfが閲覧出来る
#function p2m() {
#  pdftohtml $1 -stdout | w3m -o fold_line=true -T text/html;
#}
function p2m() {
  pdftohtml $1 -stdout | w3m -T text/html;
}

alias la="ls -a"
alias ll="ls -l"
alias du="du -h"
alias df="df -h"

[ -f ~/.bundler-exec.sh ] && source ~/.bundler-exec.sh
