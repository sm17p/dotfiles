# ls/exa/eza
set -x LS_COLORS (vivid generate catppuccin-frappe)

# Nix
fish_add_path -Pm /etc/profiles/per-user/$USER/bin

# fnm shell env
fnm env --use-on-cd | source

# pnpm
set -x PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path -P "$PNPM_HOME"

# local bin
fish_add_path -P "$HOME/.local/bin"

function expose_app_to_path
    set -f app $argv[1]

    if test -d ~/"Applications/$app.app"
        fish_add_path -P ~/"Applications/$app.app/Contents/MacOS"
    end
    if test -d "/Applications/$app.app"
        fish_add_path -P "/Applications/$app.app/Contents/MacOS"
    end
end

# expose_app_to_path "Visual Studio Code"
expose_app_to_path Ghostty

# suppress greeting
set fish_greeting