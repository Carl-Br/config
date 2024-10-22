# Macos:  point to this zsh config
# ln -s ~/.config/zsh/.zshrc ~/.zshrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias pip='python3 -m pip'
alias vim='nvim'
alias air='~/go/bin/air'
alias tmux="tmux -f ~/.config/tmux/tmux.conf" # add config to tmux

export PATH=$PATH:~/go/bin
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#808080'

export JAVA_HOME=$(/usr/libexec/java_home)

#zoxide
eval "$(zoxide init --cmd cd zsh)" # should be at the end of the config file
