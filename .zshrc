if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
  fi
  #neofetch
echo "zshrc"

fpath+=("$HOME/.anyenv/envs/nodenv/versions/11.13.0/lib/node_modules/pure-prompt/functions")


#export EDITOR=vim        # エディタをvimに設定
bindkey -e               # キーバインドをemacsモードに設定
#bindkey -v              # キーバインドをviモードに設定

# 色を使用出来るようにする
autoload -Uz colors
colors

#補完機能を有効にする
autoload -U compinit
compinit -u
setopt auto_list               # 補完候補を一覧で表示する(d)
setopt auto_menu               # 補完キー連打で補完候補を順に表示する(d)
setopt list_packed             # 補完候補をできるだけ詰めて表示する
setopt list_types              # 補完候補にファイルの種類も表示する


# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
#PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
#%# "

autoload -Uz promptinit
promptinit
prompt pure
#prompt spaceship

#履歴に実行日時も追加
HISTTIMEFORMAT='%F %T '

setopt HIST_IGNORE_DUPS           # 前と重複する行は記録しない
setopt HIST_IGNORE_ALL_DUPS       # 履歴中の重複行をファイル記録前に無くす
setopt HIST_FIND_NO_DUPS          # 履歴検索中、(連続してなくとも)重複を飛ばす


# ディレクトリ名を入力するだけで移動
setopt auto_cd

# 移動したディレクトリを記録しておく。"cd -[Tab]"で移動履歴を一覧
setopt auto_pushd

# コマンドのスペルを訂正する
setopt correct

setopt magic_equal_subst # =以降も補完する(--prefix=/usrなど)

# cd した先のディレクトリをディレクトリスタックに追加する
# # ディレクトリスタックとは今までに行ったディレクトリの履歴のこと
# # `cd +<Tab>` でディレクトリの履歴が表示され、そこに移動できる
setopt auto_pushd

# # pushd したとき、ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# # 拡張 glob を有効にする
# # glob とはパス名にマッチするワイルドカードパターンのこと
# # （たとえば `mv hoge.* ~/dir` における "*"）
# # 拡張 glob を有効にすると # ~ ^ もパターンとして扱われる
# # どういう意味を持つかは `man zshexpn` の FILENAME GENERATION を参照
setopt extended_glob

# # 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# # コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# # コマンドがスペースで始まる場合、コマンド履歴に追加しない
# # 例： <Space>echo hello と入力
setopt hist_ignore_space

#補完で小文字も大文字にマッチさせる
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#マッチング規則の変更をまずなし（''）でやって，マッチするものがなければ 'm:{a-z}={A-Z} r:|[-_.]=**' で小文字を大文字に置換しつつ補完すると同時に，右側に-か_か.が来る所には * を補ったかのように補完して、それでもなければ大文字を小文字に置き換えるルールを追加して補完する
#https://gihyo.jp/dev/serial/01/zsh-book/0005
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z} r:|[-_.]=**' '+m:{A-Z}={a-z}'


# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..


HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

#utoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end #sudo の後のコマンドでエイリアスを有効にする


###Ls Color ###
# 色の設定
#export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色の設定
#export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# ZLS_COLORSとは？
#export ZLS_COLORS=$LS_COLORS
# lsコマンド時、自動で色がつく(ls -Gのようなもの？)
#export CLICOLOR=true
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

autoload -Uz zmv
alias zmv='noglob zmv -W'
alias zcp='zmv -C'


##OS 別の設定
#case ${OSTYPE} in
#    darwin*)
#        #Mac用の設定
#        export CLICOLOR=1
#        alias ls='ls -G -F'
#        ;;
#    linux*)
#        #Linux用の設定
#        alias ls='ls -F --color=auto'
#        ;;
#esac

# tmuxが起動していない場合にalias設定を行う
if [ $SHLVL = 1 ]; then
    # tmuxにセッションがなかったら新規セッションを立ち上げた際に分割処理設定を読み込む
    alias tmux="tmux -2 attach || tmux -2 new-session \; source-file ~/.tmux/new-session"
fi
#export PATH="/usr/local/bin:$PATH"
fpath=(/usr/local/share/zsh-completions $fpath)
export PATH="/usr/local/sbin:$PATH"

if [ $HOME/.zshrc -nt $HOME/.zshrc.zwc ];then
  echo "compiling zshrc..."
  zcompile $HOME/.zshrc
fi
if [ $HOME/.bashAliases -nt $HOME/.bashAliases.zwc ];then
  echo "compiling bashAliases..."
  zcompile $HOME/.bashAliases
fi

if [ "$(uname)" = 'Darwin' ];then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
  #path+="/usr/local/lib/ruby/gems/2.7.0/bin"
elif [ "$(uname)" = 'linux' ];then
fi
#export NVM_DIR="$HOME/.nvm"
#  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/Users/kouheiyamada/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kouheiyamada/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/Users/kouheiyamada/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kouheiyamada/google-cloud-sdk/completion.zsh.inc'; fi

#export LDFLAGS="-L/usr/local/opt/python@3.8/lib"

if [ -e $HOME/.bashAliases ];then
  source $HOME/.bashAliases
elif [ -L $HOME/.bashAliases ];then
  source $HOME/.bashAliases
fi

if [ -e $HOME/.bash_aliases ];then
  source $HOME/.bash_aliases
elif [ -L $HOME/.bash_aliases ];then
  source $HOME/.bash_aliases
fi
#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source $(dirname $(gem which colorls))/tab_complete.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
