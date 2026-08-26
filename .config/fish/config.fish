# ~/.config/fish/config.fish
# Modular config lives in conf.d/ — this file is intentionally minimal.

if status is-interactive
    starship init fish | source
end

if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c)
end

set -gx PACMAN_AUTH doas

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
