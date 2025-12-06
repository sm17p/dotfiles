{
  pkgs,
  inputs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;
      extensions = pkgs.nix4vscode.forVscode [
        "antfu.unocss"
        "astro-build.astro-vscode"
        "biomejs.biome"
        "blazejkustra.react-compiler-marker"
        "bradlc.vscode-tailwindcss"
        "catppuccin.catppuccin-vsc"
        "chakrounanas.turbo-console-log"
        "davidanson.vscode-markdownlint"
        "dbaeumer.vscode-eslint"
        "dprint.dprint"
        "esafirm.kotlin-formatter"
        "esbenp.prettier-vscode"
        "fill-labs.dependi"
        "firsttris.vscode-jest-runner"
        "fwcd.kotlin"
        "github.copilot"
        "github.copilot-chat"
        "github.vscode-github-actions"
        "hverlin.mise-vscode"
        "inlang.vs-code-extension"
        "itssoumit.run-rspec"
        "jjk.jjk"
        "jnoortheen.nix-ide"
        "kamadorueda.alejandra"
        "kilocode.kilo-code"
        "mathiasfrohlich.kotlin"
        "melishev.feather-vscode"
        "mhutchie.git-graph"
        "million.million-lint"
        "mkhl.direnv"
        "moonrepo.moon-console"
        "ms-azuretools.vscode-containers"
        "ms-playwright.playwright"
        "ms-vscode-remote.remote-containers"
        "ms-vscode.anycode-kotlin"
        "ms-vscode.anycode-rust"
        "ms-vscode.makefile-tools"
        "ms-vscode.vscode-typescript-next"
        "orta.vscode-jest"
        "oxc.oxc-vscode"
        "pkief.material-icon-theme"
        "redhat.vscode-yaml"
        "rust-lang.rust-analyzer"
        "shopify.ruby-extensions-pack"
        "shopify.ruby-lsp"
        "sorbet.sorbet-vscode-extension"
        "streetsidesoftware.code-spell-checker"
        "streetsidesoftware.code-spell-checker-cspell-bundled-dictionaries"
        "svelte.svelte-vscode"
        "tamasfe.even-better-toml"
        "tauri-apps.tauri-vscode"
        "typescriptteam.native-preview"
        "tyriar.sort-lines"
        "vadimcn.vscode-lldb"
        "vercel.turbo-vsc"
        "vitaliymaz.vscode-svg-previewer"
        "vitest.explorer"
        "vscjava.vscode-gradle"
        "vscode-icons-team.vscode-icons"
        "waderyan.gitblame"
        "wayou.vscode-todo-highlight"
        "wmaurer.change-case"
        "yrm.type-challenges"
      ];
      userSettings = {
        "alejandra.program" = "alejandra";
        "application.shellEnvironmentResolutionTimeout" = 20;
        "biome.suggestInstallingGlobally" = false;
        "catppuccin.syncWithIconPack" = false;
        "cSpell.language" = "en-GB";
        "debug.javascript.defaultRuntimeExecutable" = {
          "pwa-node" = "/Users/yoda/.local/share/mise/shims/node";
        };
        "diffEditor.ignoreTrimWhitespace" = false;
        "dprint.experimentalLsp" = false;
        "dprint.path" = "/Users/yoda/.cargo/bin/dprint";
        "editor.codeLensFontFamily" = "Iosevka";
        "editor.defaultFormatter" = "Shopify.ruby-lsp";
        "editor.experimental.asyncTokenization" = false;
        "editor.fontFamily" = "Iosevka Nerd Font Mono, Menlo, Monaco, 'Courier New', monospace";
        "editor.fontLigatures" = true;
        "editor.inlayHints.fontFamily" = "Iosevka";
        "git.blame.editorDecoration.enabled" = true;
        "git.openRepositoryInParentFolders" = "never";
        "gitblame.inlineMessageEnabled" = true;
        "javascript.referencesCodeLens.enabled" = true;
        "javascript.referencesCodeLens.showOnAllFunctions" = true;
        "jjk.jjPath" = "/run/current-system/sw/bin/jj";
        "kilo-code.allowedCommands" = [
          "git log"
          "git diff"
          "git show"
          "jj diff"
          "jj log"
          "npm run test:e2e"
          "npm install"
          "tsc"
          "npx tsc"
          "npx eslint --fix --max-warnings 0"
        ];
        "kilo-code.deniedCommands" = [];
        "kotlin.debugAdapter.enabled" = false;
        "kotlin.languageServer.enabled" = false;
        "mise.binPath" = "/run/current-system/sw/bin/mise";
        "nix.enableLanguageServer" = true;
        "nix.formatterPath" = "alejandra";
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          nil = {
            formatting = {
              command = ["alejandra"];
            };
          };
        };
        "playwright.reuseBrowser" = false;
        "playwright.showTrace" = false;
        "rubyLsp.addonSettings" = {
          "Ruby LSP Rails" = {
            something = true;
          };
        };
        "rubyLsp.enabledFeatures" = {
          inlayHint = false;
        };
        "rubyLsp.formatter" = "auto";
        "rubyLsp.rubyExecutablePath" = "/Users/yoda/.local/share/mise/installs/ruby/3.4.3/bin/ruby";
        "rubyLsp.rubyVersionManager" = {
          identifier = "mise";
        };
        "settingsSync.keybindingsPerPlatform" = false;
        "sherlock.userId" = "3da279b3-700c-4d77-93e8-c8ae2ff8ec80";
        "svelte.enable-ts-plugin" = true;
        "terminal.external.osxExec" = "Alacritty.app";
        "terminal.integrated.defaultProfile.osx" = "Nix Fish";
        "terminal.integrated.profiles.osx" = {
          "Nix Fish" = {path = "/run/current-system/sw/bin/fish";};
          "Nix ZSH" = {path = "/run/current-system/sw/bin/zsh";};
          bash = {
            path = "bash";
            args = ["-l"];
            icon = "terminal-bash";
          };
          fish = {
            path = "fish";
            args = ["-l"];
          };
          pwsh = {
            path = "pwsh";
            icon = "terminal-powershell";
          };
          tmux = {
            path = "tmux";
            icon = "terminal-tmux";
          };
          zsh = {
            path = "zsh";
            args = ["-l"];
          };
        };
        "terminal.integrated.shellIntegration.enabled" = true;
        "typeChallenges.workspaceFolder" = "/Users/yoda/.typeChallenges";
        "typescript.experimental.useTsgo" = false;
        "typescript.inlayHints.variableTypes.enabled" = true;
        "typescript.referencesCodeLens.enabled" = true;
        "typescript.referencesCodeLens.showOnAllFunctions" = true;
        "vitest.cliArguments" = "--browser=chromium";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.productIconTheme" = "feather-vscode";
        "[css]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
        "[dockercompose]" = {
          "editor.autoIndent" = "advanced";
          "editor.defaultFormatter" = "redhat.vscode-yaml";
          "editor.insertSpaces" = true;
          "editor.quickSuggestions" = {
            comments = false;
            other = true;
            strings = true;
          };
          "editor.tabSize" = 2;
        };
        "[github-actions-workflow]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[html]" = {
          "editor.defaultFormatter" = "dprint.dprint";
        };
        "[javascript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        "[markdown]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[nix]" = {
          "editor.defaultFormatter" = "kamadorueda.alejandra";
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnType" = false;
        };
        "[svelte]" = {
          "editor.defaultFormatter" = "svelte.svelte-vscode";
        };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[yaml]" = {
          "editor.defaultFormatter" = "redhat.vscode-yaml";
        };
      };
    };
  };
}
