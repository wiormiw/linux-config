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
alias acachedef="paru -c && sudo pacman -Sc"
alias acachemore="paru -c && sudo pacman -Scc"
alias aorphan="sudo pacman -Rns $(pacman -Qdtq)"
alias sdocker="sudo systemctl start docker.service docker.socket containerd.service"
alias resdocker="sudo systemctl restart docker.service docker.socket containerd.service"
alias stopdocker="sudo systemctl stop docker.service docker.socket containerd.service"
alias statdocker="systemctl status docker.service docker.socket containerd.service"
alias aurls="pacman -Qme"

# Init
fastfetch
eval "$(oh-my-posh init bash --config $HOME/.poshthemes/catppuccin_macchiato.omp.json)"
