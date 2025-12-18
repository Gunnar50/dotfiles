# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
source /opt/homebrew/cellar/powerlevel10k/1.20.0/share/powerlevel10k/powerlevel10k.zsh-theme

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(globalias)

source $ZSH/oh-my-zsh.sh

# User configuration

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export EDITOR=nvim

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/bin:$PATH"

if [ -f ~/bin/google-cloud-sdk/path.zsh.inc ]; then
  source ~/bin/google-cloud-sdk/path.zsh.inc
fi
if [ -f ~/bin/google-cloud-sdk/completion.zsh.inc ]; then
  source ~/bin/google-cloud-sdk/completion.zsh.inc
fi

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# General
alias sz='source ~/.zshrc'
alias vim='nvim'

# Folders
function cd() {
  builtin cd "$@" && ls -p --color=auto
}
alias cdgoogle='cd ~/Documents/Phantom/google'
alias cdphantom='cd ~/Documents/Phantom'
alias cdprojects='cd ~/Documents/Projects'
alias ..='cd ..'
alias ls='ls -p --color=auto'

# gcloud
alias setaccount='gcloud config set account gustavo@phntms.com'

# git alias
alias gca='git commit --amend --no-edit'
alias gcp='git cherry-pick'
alias gpcr='git push origin HEAD:refs/for/develop'
alias gpcrm='git push origin HEAD:refs/for/main'
alias gfr='git fetch origin && git rebase origin/develop'
alias gfrm='git fetch origin && git rebase origin/main'
alias gl='git log -n 5'
alias gssh='eval "$(ssh-agent -s)"'
alias gsu='git stash -u'
alias gsp='git stash pop'
alias ga='git add .'
alias gch='git checkout'
alias gc='git commit'
alias gp='git pull'


function gri() {
  git rebase -i "$1"^
}

function atf() {
  # Check if 'all-test' is defined in package.json
  if grep -q '"all-test"' package.json; then
    # If 'all-test' script exists, run the following
    npm run all-test && npm run all-fix
  elif grep -q '"prod:test"' package.json; then
    npm run prod:test && npm run prod:fix
  else
    # If 'all-test' script does not exist, run the fallback commands
    npm run prod_server:test && npm run prod_server:fix
  fi
}

function af() {
  # Check if 'all-test' is defined in package.json
  if grep -q '"all-fix"' package.json; then
    # If 'all-test' script exists, run the following
    npm run all-fix
  elif grep -q '"prod:fix"' package.json; then
    npm run prod:fix
  else
    # If 'all-test' script does not exist, run the fallback commands
    npm run prod_server:fix
  fi
}

function rt() {
  if [ $# -eq 2 ]; then
    # If two arguments are provided, run the first command
    npm run "${1}:test" -- -k "$2" -s -vvv
  else
    # If fewer than two arguments are provided, run the fallback command
    npm run test -- -k "$1" -s -vvv
  fi
}

function updatenpm() {
  npm ci
  npm run lint
  npm run build
  npm start
}


# Load Angular CLI autocompletion.
source <(ng completion script)
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

# Unset PAGER which is LESS used by oh-my-zsh
export PAGER=""

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (must be last)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function fzf_history() {
  # FZF-based history search (Warp-like command popup)
  if command -v fzf >/dev/null; then
    fzf-history-widget() {
      local selected

      # Show history newest-first, unique, no line numbers
      selected=$(
        fc -ln 1 | tac | awk '!seen[$0]++' | \
        fzf --height 40% --border
      )

      # If user cancelled (Esc/Ctrl-C), do nothing
      [[ -z "$selected" ]] && return 0

      BUFFER=$selected
      CURSOR=${#BUFFER}
      zle redisplay
      zle accept-line
    }

    # Register widget with zle
    zle -N fzf-history-widget

    # Bind Ctrl-r (override default incremental search)
    bindkey '^R' fzf-history-widget

    # Bind Up Arrow
    bindkey '^[OA' fzf-history-widget
  fi
}
function fzf_history2() {
  # FZF-based history search (Warp-like command popup)
  if command -v fzf >/dev/null; then
    fzf-history-widget() {
      local out key selected

      # Show history newest-first, unique, no line numbers
      # --expect captures which key was pressed
      out=$(
        fc -ln 1 | tac | awk '!seen[$0]++' | \
        fzf --height 40% --border --expect=ctrl-e
      )

      # If user cancelled (Esc/Ctrl-C), do nothing
      [[ -z "$out" ]] && return 0

      # First line is the key pressed, second line is the selected item
      key=$(echo "$out" | head -n1)
      selected=$(echo "$out" | tail -n1)

      [[ -z "$selected" ]] && return 0

      BUFFER=$selected
      CURSOR=${#BUFFER}

      # If Ctrl-E was pressed, just insert for editing
      if [[ "$key" == "ctrl-e" ]]; then
        zle redisplay
      else
        # Enter was pressed, execute immediately
        zle accept-line
      fi
    }

    # Register widget with zle
    zle -N fzf-history-widget

    # Bind Ctrl-r (override default incremental search)
    bindkey '^R' fzf-history-widget

    # Bind Up Arrow
    bindkey '^[OA' fzf-history-widget
  fi
}

fzf_history
fzf_history2

# fzf-history-widget-accept() {
#   fzf-history-widget
#   zle accept-line
# }
# zle -N fzf-history-widget-accept
# bindkey '^R' fzf-history-widget

# Accept suggestion with right arrow or Ctrl-f
bindkey '^F' autosuggest-accept
bindkey '^[f' autosuggest-forward-word
