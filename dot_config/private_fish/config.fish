set -g fish_greeting
set -x CODEPATH $HOME/code
set -x GOPATH $CODEPATH/go
set -x PATH /opt/homebrew/bin /opt/homebrew/opt/postgresql@17/bin $GOPATH/bin $HOME/.krew/bin $PATH

alias assume="source assume"
alias cat=bat
alias cd=z
alias k=kubectl
alias ls=eza
alias vim=nvim
alias tailscale=/Applications/Tailscale.app/Contents/MacOS/Tailscale
alias npm=pnpm

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

if status is-interactive
  starship init fish | source
  mise activate fish | source
  zoxide init fish | source
  atuin init fish --disable-up-arrow | source
end

