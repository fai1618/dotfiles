echo "bashrc"
if [ "$(uname)" = 'Linux' ];then
  # ~/.bashrc: executed by bash(1) for non-login shells.
  # see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
  # for examples

  # If not running interactively, don't do anything
  [ -z "$PS1" ] && return

  # don't put duplicate lines or lines starting with space in the history.
  # See bash(1) for more options
  HISTCONTROL=ignoreboth

  # append to the history file, don't overwrite it
  shopt -s histappend

  # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
  HISTSIZE=1000
  HISTFILESIZE=2000

  # check the window size after each command and, if necessary,
  # update the values of LINES and COLUMNS.
  shopt -s checkwinsize

  # If set, the pattern "**" used in a pathname expansion context will
  # match all files and zero or more directories and subdirectories.
  #shopt -s globstar

  # make less more friendly for non-text input files, see lesspipe(1)
  #[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  # set variable identifying the chroot you work in (used in the prompt below)
  if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
  fi

  # set a fancy prompt (non-color, unless we know we "want" color)
  case "$TERM" in
    xterm-color) color_prompt=yes;;
  esac

  # uncomment for a colored prompt, if the terminal has the capability; turned
  # off by default to not distract the user: the focus in a terminal window
  # should be on the output of commands, not on the prompt
  force_color_prompt=yes

  if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
      # We have color support; assume it's compliant with Ecma-48
      # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
      # a case would tend to support setf rather than setaf.)
      color_prompt=yes
    else
      color_prompt=
    fi
  fi

  if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \$\[\033[00m\] '
  else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  fi
  unset color_prompt force_color_prompt

  # If this is an xterm set the title to user@host:dir
  case "$TERM" in
    xterm*|rxvt*)
      PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
      ;;
    *)
      ;;
  esac

  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi

  # some more ls aliases
  #alias ll='ls -l'
  #alias la='ls -A'
  #alias l='ls -CF'

  # Alias definitions.
  # You may want to put all your additions into a separate file like
  # ~/.bash_aliases, instead of adding them here directly.
  # See /usr/share/doc/bash-doc/examples in the bash-doc package.

  # enable programmable completion features (you don't need to enable
  # this, if it's already enabled in /etc/bash.bashrc and /etc/profile
  # sources /etc/bash.bashrc).
  if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
  fi

  # MOTD
  let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
  let secs=$((${upSeconds}%60))
  let mins=$((${upSeconds}/60%60))
  let hours=$((${upSeconds}/3600%24))
  let days=$((${upSeconds}/86400))
  UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

  # get the load averages
  read one five fifteen rest < /proc/loadavg
fi
#my settings
if [ "$(uname)" = "Darwin" ]; then
  if [ -e $HOME/.bash/itunes_completion.sh ]; then
    source $HOME/.bash/itunes_completion.sh
  fi
  eval "$(rbenv init -)"
 powerline-daemon -q
 . ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh
fi

if [ -e $HOME/.bashAliases ]; then
  echo ".bashAliases exist"
  . $HOME/.bashAliases
elif [ -L $HOME/.bashAliases ];then
  echo ".bashAliases is ln"
  . $HOME/.bashAliases
fi

if [ -e $HOME/.bash_aliases ]; then
  echo "bash_aliases exist"
  . $HOME/.bash_aliases
elif [ -L $HOME/.bash_aliases ];then
  echo "bash_aliases is ln"
  . $HOME/.bash_aliases
fi

if [ "$(uname)" = "Linux" ];then
  $HOME/shellScripts/ip.sh
  echo "$(tput setaf 2)
   .~~.   .~~.    `date +"%A, %e %B %Y, %r"`
  '. \ ' ' / .'   `uname -srmo`$(tput setaf 1)
   .~ .~~~..~.    
  : .~.'~'.~. :   Uptime.............: ${UPTIME}
 ~ (   ) (   ) ~  Memory.............: `cat /proc/meminfo | grep MemFree | awk {'print $2'}`kB (Free) / `cat /proc/meminfo | grep MemTotal | awk {'print $2'}`kB (Total)
( : '~'.~.'~' : ) Load Averages......: ${one}, ${five}, ${fifteen} (1, 5, 15 min)
 ~ .~ (   ) ~. ~  Running Processes..: `ps ax | wc -l | tr -d " "`
  (  : '~' :  )   IP Addresses.......: `cat $HOME/ip`
   '~ .~~~. ~'    Free Disk Space SD.: `df -Pk | grep -E '/root' | awk '{ print $4 }' | awk -F '.' '{ print $1 }'`k on /root 
       '~'        CPU Temperature....: `exec -- /opt/vc/bin/vcgencmd measure_temp | cut -c "6-9"` C 
$(tput sgr0)"
fi
