[[ -o interactive ]] || return

HISTSIZE=1000
SAVEHIST=2000
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"

setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

if [[ -z "${debian_chroot:-}" && -r /etc/debian_chroot ]]; then
  debian_chroot="$(< /etc/debian_chroot)"
fi

autoload -Uz colors && colors

case "$TERM" in
  xterm-color|*-256color) color_prompt=yes ;;
esac

if [[ "$color_prompt" == yes ]]; then
  PROMPT='${debian_chroot:+(%F{green}(%f$debian_chroot%F{green})%f)}%F{green}%n@%m%f:%F{blue}%~%f$ '
else
  PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~$ '
fi
unset color_prompt

case "$TERM" in
  xterm*|rxvt*)
    precmd() { print -Pn "\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a" }
  ;;
esac

if [[ -x /usr/bin/dircolors ]]; then
  if [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi

  alias ls='ls --color=auto'
  alias ff='fastfetch'
  alias cl='clear'
  alias poweroff='systemctl poweroff'
  alias reboot='systemctl reboot'
  alias suspend='systemctl suspend'
fi

if [[ -f ~/.zsh_aliases ]]; then
  source ~/.zsh_aliases
fi

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=* r:|=*'

if [[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

eval "$(starship init zsh)"
source "$HOME/.cargo/env"
export PATH="$PATH:/usr/local/go/bin"
export PATH=$HOME/.local/bin:$PATH
export PATH="$PATH:$HOME/go/bin"
