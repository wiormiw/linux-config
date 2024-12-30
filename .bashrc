#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=/home/alwaysjoy/.local/bin:$PATH

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# My Alias
alias acleancache="sudo pacman -Scc"
alias aorphan="sudo pacman -Rns $(pacman -Qdtq)"

# Init
fastfetch
eval "$(oh-my-posh init bash --config $HOME/.poshthemes/catppuccin_macchiato.omp.json)"
