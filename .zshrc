# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="af-magic"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

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

# DHlavaty own aliases
alias p='cd ~/Developer'
alias code='codium'
alias zshrc='code ~/.zshrc'
alias rmnodemodules='find . -type d -name node_modules -prune | xargs rm -rf'
alias targz='tar -cvzf'
alias untargz='tar -xf'
alias searchstringhere='grep -rnwi . -e'
alias searchstringherepartial='grep -rni . -e'
alias mc='mc -u'
# DHlavaty frequently used working shortcuts
alias pr='yarn run pr'
alias prf='yarn run formatter ; yarn run pr && Say "good" || Say "error"'
alias dev='yarn run dev'
alias sb='yarn run storybook'
alias sc='yarn run storybook:screenshots:docker ; Say "Done"'
alias op='yarn run opendiff'

function gitc() {
    git checkout --detach origin/$@
}

alias cdf='f() { cd "$1" && echo "$1" && git fetch -v && cd ..};f'

alias nxdev='nvm use && yarn run nx serve my-events'
alias nxdevs='nvm use && yarn run nx serve my-events --ssl'
alias nxsetup='nvm use && yarn run nx setup my-events'
alias nxreset='nvm use && rmnodemodules && yarn install && yarn run reset ; Say "complete"'
alias nxf='yarn run nx format:write'
alias nxpr='yarn run nx pr my-events && Say "NX good" || Say "NX error"'
alias apr='nvm use && yarn run nx format:write && yarn run nx typecheck admin && yarn run nx lint admin && Say "ADMIN good" || Say "ADMIN error"'
alias adev='nvm use && yarn run admin:start'
# DHlavaty frequently used working shortcuts - Kubernetes
alias kgp='kubectl get pods -l app=analytics'
alias kgp2='kubectl get pods -l app=analytics2'
alias kl='kubectl logs'
alias klf='kubectl logs -f'

alias gitrebasemaster='git fetch origin master:master && git rebase master'

# DHlavaty docker aliases inspired by https://blog.ropnop.com/docker-for-pentesters/
alias dockerbash="docker run --rm -i -t --entrypoint=/bin/bash"
alias dockersh="docker run --rm -i -t --entrypoint=/bin/sh"
alias httpshere='docker run --rm -it -p 80:80 -p 443:443 -v "${PWD}:/srv/data" dhlavaty/httpshere'
alias webdavhere='docker run --rm -it -p 80:80 -v "${PWD}:/srv/data/share" dhlavaty/webdavhere'

alias heic2jpghere='docker run --rm -v "${PWD}:/workdir" dhlavaty/heic2jpg'

function dockerbashhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}
function dockerbashintelhere() {
    dirname=${PWD##*/}
    docker run --rm -it --platform=linux/amd64 --entrypoint=/bin/bash --publish 8080:8080 -v `pwd`:/${dirname} -w /${dirname} "$@"
}
function dockershhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
}

# to login use smb://192.168.100.xxx/share
function smbservehere() {
    local sharename
    [[ -z $1 ]] && sharename="SHARE" || sharename=$1
    # docker run --rm -it -p 445:445 -v "${PWD}:/tmp/serve" rflathers/impacket smbserver.py -smb2support $sharename /tmp/serve
    # For 'dhlavaty/mypacket' docker image see: https://gist.github.com/dhlavaty/82fc2bde306712b975455b645d0afb90
    docker run --rm -it --entrypoint "/opt/venv/bin/python" -p 445:445 -v "${PWD}:/tmp/serve" dhlavaty/mypacket /opt/venv/bin/smbserver.py $sharename /tmp/serve
}

# FNM - Fast Node version manager
# eval "`fnm env`"
# alias nvm='fnm'

# DHlavaty - nechcem sharovanu historiu
# https://github.com/ohmyzsh/ohmyzsh/issues/2537
# http://zsh.sourceforge.net/Doc/Release/Options.html
unsetopt SHARE_HISTORY

# DHlavaty kvoli homebrew
export PATH="/usr/local/sbin:$PATH"
# DHlavaty kvoli dockeru
export PATH=$PATH:~/.docker/bin

