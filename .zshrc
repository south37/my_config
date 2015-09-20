# PATH等の設定
# http://yonchu.hatenablog.com/entry/20120415/1334506855
# 重複パスを登録しない
typeset -U path cdpath fpath manpath
# sudo用のpathを設定
typeset -xT SUDO_PATH sudo_path
typeset -U sudo_path
sudo_path=({/usr/local,/usr,}/sbin(N-/))
# pathを設定
path=(~/bin(N-/) /usr/local/bin(N-/) ${path})

#   typeset
#    -U 重複パスを登録しない
#    -x exportも同時に行う
#    -T 環境変数へ紐付け
#
#   path=xxxx(N-/)
#     (N-/): 存在しないディレクトリは登録しない
#     パス(...): ...という条件にマッチするパスのみ残す
#        N: NULL_GLOBオプションを設定。
#           globがマッチしなかったり存在しないパスを無視する
#        -: シンボリックリンク先のパスを評価
#        /: ディレクトリのみ残す
#        .: 通常のファイルのみ残す

# ^D でshellから抜けない様にする
# 参考: http://www.ki.nu/~makoto/diary/2009/06/21/1.html
setopt IGNOREEOF

# Homebrew用
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="$PATH:/usr/local/share/npm/bin"
export PATH="$(brew --prefix josegonzalez/php/php55)/bin:$PATH"

# Bundler用
export BUNDLER_EDITOR=vim

# swift用
export PATH="/Applications/Xcode6-Beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:$PATH"

# sbt用SBT_OPTS
export SBT_OPTS="-XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=384M"

# PostgresをPATHに追加
export PATH="/Applications/Postgres.app/Contents/Versions/9.3/bin:$PATH"

# nodebrew用
export PATH="$HOME/.nodebrew/current/bin:$PATH"

# pkg-config用PATH
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:/usr/X11/lib/pkgconfig"

# pythonでopenCV使う
export PYTHONPATH="/usr/local/Cellar/opencv/2.4.5/lib/python2.7/site-packages:$PYTHONPATH"

# rubyでrsruby用
export R_HOME="/usr/local/bin/R"

# ghq getのalias
alias repo='ghq get'

# 3秒以上かかった処理は詳細表示
REPORTTIME=3

# for zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)
# zshの補完
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
# Homebrewのコマンド補完を有効にする
fpath=(~/.zsh/functions/ $fpath)
# 自作した補完関数等は~/.zsh/functions/Completionに置く
fpath=(~/.zsh/functions/Completion(N-/) ${fpath})

# 補完機能
autoload -Uz compinit
compinit -u

# 先方予測機能
#autoload predict-on
#predict-on

# 保管候補を詰めて表示
setopt list_packed

# コマンド訂正
setopt correct

# コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_dups   # ignore duplication command history list
setopt share_history      # share command history data

# コマンド履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# 移動したディレクトリを記録しておく。"cd -[Tab]"で移動rirekiwo
setopt auto_pushd

# gitのbranch名をプロンプトに表示
# 参考: https://gist.github.com/otiai10/8034038
function branch-status-check {
    local prefix branchname suffix
    # .gitの中だから除外
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    branchname=`get-branch-name`
    # ブランチ名が無いので除外
    if [[ -z $branchname ]]; then
        return
    fi
    prefix=`get-branch-status` #色だけ返ってくる
    suffix='%{'${reset_color}'%}'
    echo ${prefix}${branchname}${suffix}
}
function get-branch-name {
    # gitディレクトリじゃない場合のエラーは捨てます
    echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}
function get-branch-status {
    local res color
    output=`git status --short 2> /dev/null`
    if [ -z "$output" ]; then
        res=':' # status Clean
        color='%{'${fg[green]}'%}'
    elif [[ $output =~ "[\n]?\?\? " ]]; then
        res='?:' # Untracked
        color='%{'${fg[yellow]}'%}'
    elif [[ $output =~ "[\n]? M " ]]; then
        res='M:' # Modified
        color='%{'${fg[red]}'%}'
    else
        res='A:' # Added to commit
        color='%{'${fg[cyan]}'%}'
    fi
    # echo ${color}${res}'%{'${reset_color}'%}'
    echo ${color} # 色だけ返す
}

# プロンプト
autoload -U colors; colors
PROMPT='%F{blue}[%n@%m]%f %~ `branch-status-check`'$'\n$ ' # gitのbranch名を表示
# setopt transient_rprompt
setopt prompt_subst #表示毎にPROMPTで設定されている文字列を評価する

# $grep
export GREP_COLOR='1;37;41'
alias grep='grep -E --color=auto'

# ctagsをhomebrewで入れた物を使用
alias ctags='/usr/local/Cellar/ctags/5.8/bin/ctags'

# カラー表示
export CLICOLOR=1
export LSCOLORS=gxfxbxdxcxegedabagacad

# od
alias od='od -tx1z -Ax -v'

# alias
alias la='ls -a'
alias ll='ls -hl'
alias rm='rm -i'

alias em=emacs
alias soz='source ~/.zshrc'
alias vzsh='vim ~/.zshrc'
alias vvim='vim ~/.vimrc'

# r7kamuraさんのパクリalias
pvim() { peco | xargs sh -c 'vim "$0" < /dev/tty' }
pdo() { peco | while read LINE; do $@ $LINE; done }
alias c='find ./ -type d | pdo cd'
alias p='git ls-files | pvim'
alias e='ghq list -p | pdo cd'

# cd系
alias cdh='cd ~'
alias cda='cd ~/Dropbox/experiment/text_file/analysis_script'
alias cdp='cd ~/Documents/programs'
alias cdj='cd app/assets/javascripts'
alias cdd='cd ~/Dropbox/docs'
alias cdw='cd ~/Dropbox/master-thesis'
alias cdi='cd ~/Documents/programs/intern/wantedly/projects/app-ios'

# bundle exec
alias be='bundle exec'

# coffee script
alias cof='coffee'

set -o noclobber

# erlangの起動
alias erl='/usr/local/opt/erlang/lib/erlang/bin/erl*'

# hubをgitのaliasに
eval "$(hub alias -s)"

# git関連
alias ga='git add'
alias gd='git diff'
alias gdh='git diff HEAD'
alias gdhh='git diff HEAD\^'
alias gcm='git commit -m'
alias gam='git commit -am'
alias gs='git status'
alias gsn='git status -s | cut -c4-'
alias gl='git logg'
alias gll='git log -p'
alias glg="git log --graph --pretty=format:'%d %an: %s %ar %h'"
alias gco='git checkout'
alias gb='git branch'
alias gsub='git submodule'
alias grm='git rm --cached'

# peco でgitlogからハッシュを取る
alias glh="glg | peco | awk -F ' ' '{ print $NF }'"

# rails のmigrationファイルのうち最新のものを取得
alias last_migration='ls db/migrate/* | tail -n1'
alias vlm='vim `last_migration`'

# agの結果をpagerで表示
# alias ag='ag --pager="less -R"'

# gccでboost読み込み
CPLUS_INCLUDE_PATH='/usr/local/Cellar/boost/1.55.0/lib/'

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# gemをrbenv用に自動でrehashが走る形に書き換え
function gem(){
    $HOME/.rbenv/shims/gem $*
    if [ "$1" = "install" ] || [ "$1" = "i" ] || [ "$1" = "uninstall" ] || [ "$1" = "uni" ]
    then
        rbenv rehash
        rehash
    fi
}

# chef-dkをPATHに含める。
# rbenvのPATHよりも前。
# 参考: https://github.com/berkshelf/vagrant-berkshelf/issues/212
export PATH="$HOME/.chefdk/gem/ruby/2.1.0/bin:/opt/chefdk/bin:$PATH"

# sheet用設定
compdef _my_sheets sheet
function _my_sheets {
  local -a cmds
  _files -W  ~/.sheets/ -P '~/.sheets/'

  cmds=('list' 'edit' 'copy')
  _describe -t commands "subcommand" cmds

  return 1;
}

# defaultのeditorをvimに
export EDITOR=vim

# tabを見易く
function chpwd() { ls; echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"}

# file名で検索
alias findall="find ./ -name $1"

# git管理下のファイル全体から置換
# 参考: http://pg-sugarless.hatenablog.jp/entry/20130409/1365510182
# 参考2: http://stackoverflow.com/questions/4247068/sed-command-failing-on-mac-but-works-on-linux
function grepall() { git ls-files | xargs grep -l $1 }
function sedall()  { grepall $1 | xargs sed -i '' s/$1/$2/g }
# rename
function renameall() { git ls-files | grep $1 | while read LINE; do mv $LINE `echo $LINE | sed s/$1/$2/g`; done }

# capistranoにalias
alias cap="bundle exec cap"

# goの設定。ghqを使う為でもある。
# http://qiita.com/methane/items/4905f40e4772afec3e60
export GOPATH=$HOME/.go
export GOROOT=/usr/local/opt/go/libexec
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
# goコマンドをTab補完する為に読み込む。
# 参考?: http://d.hatena.ne.jp/torazuka/20140714/oimachigo
source /usr/local/share/zsh/site-functions/go

# 特定のcommitが含まれる pull req を探す
function find-pr() {
  local parent=$2||'master'
  git log $1..$2 --merges --ancestry-path --reverse --oneline | head -n1
}

function find-pr-open() {
  local pr="$(find-pr $1 $2 | awk '{print substr($5, 2)}')"
  local repo="$(git config --get remote.origin.url | sed 's/git@github.com://' | sed 's/\.git$//')"
  open "https://github.com/${repo}/pull/${pr}"
}

alias altool='/Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool'

#https://github.com/nvbn/thefuck
alias fuck='eval $(thefuck $(fc -ln -1))'

# docker用
# http://stackoverflow.com/questions/27528337/am-i-trying-to-connect-to-a-tls-enabled-daemon-without-tls
# $(boot2docker shellinit 2> /dev/null)

# for docker-machine
# https://docs.docker.com/machine/
# eval "$(docker-machine env dev)"

# tag生成
# 参考: http://qiita.com/joker1007/items/9c114a37560d6a29fe81
alias ruby-tag='ctags --langmap=RUBY:.rb --exclude="*.js"  --exclude=".git*" --sort=yes -R .'


# The next line updates PATH for the Google Cloud SDK.
source '/Users/minami/.gcp/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
source '/Users/minami/.gcp/google-cloud-sdk/completion.zsh.inc'

# dstat 関連
alias dstat-full='dstat -Tclmdrn'
alias dstat-mem='dstat -Tclm'
alias dstat-cpu='dstat -Tclr'
alias dstat-net='dstat -Tclnd'
alias dstat-disk='dstat -Tcldr'

## docker-machine 起動
# docker-machine start default
# docker-machine env default