# ls/exa/eza
set -x LS_COLORS (vivid generate catppuccin-mocha)

# Nix
fish_add_path -Pm /etc/profiles/per-user/$USER/bin

# fnm shell env
fnm env --use-on-cd --shell fish | source

# pnpm
set -x PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path -P "$PNPM_HOME"

# local bin
# fish_add_path -P "$HOME/.local/bin"

# java
set -gx JAVA_HOME (string match -r '(.+)/bin/javac' --groups 1 (realpath (type -p javac)))
# set -gx ANDROID_HOME ~/.android/sdk
# set NDK (ls -1 $ANDROID_HOME/ndk | head -n 1)
# set -gx NDK_HOME "$ANDROID_HOME/ndk/$NDK"

# rustup
fish_add_path -Pm "$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin"

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
# expose_app_to_path Ghostty

# suppress greeting
set fish_greeting

starship init fish | source
direnv hook fish | source
atuin init fish | source

