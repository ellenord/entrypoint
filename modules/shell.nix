{
  setup,
  pkgs,
  config,
  ...
}:
with setup; let
  module = trace "loading system core configuration..." ({
      environment = {
        systemPackages = with pkgs; [
          zsh
          zsh-powerlevel10k
          zsh-system-clipboard
          zsh-autosuggestions
          zsh-syntax-highlighting
          zsh-completions
        ];
      };
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions = {
          enable = true;
          async = true;
          highlightStyle = "fg=8";
        };
        syntaxHighlighting.enable = true;
        enableGlobalCompInit = true;
        shellInit = ''
          source ~/.p10k.zsh
          eval "$(direnv hook zsh)"
        '';
        promptInit = ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

          typeset -g -A key

          # Use terminfo to get the key codes for the terminal.
          key[Home]="''${terminfo[khome]}"
          key[End]="''${terminfo[kend]}"
          key[Insert]="''${terminfo[kich1]}"
          key[Backspace]="''${terminfo[kbs]}"
          key[Delete]="''${terminfo[kdch1]}"
          key[Up]="''${terminfo[kcuu1]}"
          key[Down]="''${terminfo[kcud1]}"
          key[Left]="''${terminfo[kcub1]}"
          key[Right]="''${terminfo[kcuf1]}"
          key[PageUp]="''${terminfo[kpp]}"
          key[PageDown]="''${terminfo[knp]}"
          key[Shift-Tab]="''${terminfo[kcbt]}"
          key[Control-Left]="''${terminfo[kLFT5]}"
          key[Control-Right]="''${terminfo[kRIT5]}"
          key[Ctrl-Delete]="''${terminfo[kDC5]}"
          key[Shift-Delete]="''${terminfo[kDC]}"

          # Bind the keys to their respective zle widgets.
          [[ -n "''${key[Home]}"      ]] && bindkey -- "''${key[Home]}"       beginning-of-line
          [[ -n "''${key[End]}"       ]] && bindkey -- "''${key[End]}"        end-of-line
          [[ -n "''${key[Insert]}"    ]] && bindkey -- "''${key[Insert]}"     overwrite-mode
          [[ -n "''${key[Backspace]}" ]] && bindkey -- "''${key[Backspace]}"  backward-delete-char
          [[ -n "''${key[Delete]}"    ]] && bindkey -- "''${key[Delete]}"     delete-char
          [[ -n "''${key[Up]}"        ]] && bindkey -- "''${key[Up]}"         up-line-or-history
          [[ -n "''${key[Down]}"      ]] && bindkey -- "''${key[Down]}"       down-line-or-history
          [[ -n "''${key[Left]}"      ]] && bindkey -- "''${key[Left]}"       backward-char
          [[ -n "''${key[Right]}"     ]] && bindkey -- "''${key[Right]}"      forward-char
          [[ -n "''${key[PageUp]}"    ]] && bindkey -- "''${key[PageUp]}"     beginning-of-buffer-or-history
          [[ -n "''${key[PageDown]}"  ]] && bindkey -- "''${key[PageDown]}"   end-of-buffer-or-history
          [[ -n "''${key[Shift-Tab]}" ]] && bindkey -- "''${key[Shift-Tab]}"  reverse-menu-complete
          [[ -n "''${key[Control-Left]}"  ]] && bindkey -- "''${key[Control-Left]}"  backward-word
          [[ -n "''${key[Control-Right]}" ]] && bindkey -- "''${key[Control-Right]}" forward-word
          [[ -n "''${key[Shift-Delete]}" ]] && bindkey -- "''${key[Shift-Delete]}" delete-word
          [[ -n "''${key[Ctrl-Delete]}" ]] && bindkey -- "''${key[Ctrl-Delete]}" backward-delete-word

          # Enable application mode for the terminal if supported.
          if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
            autoload -Uz add-zle-hook-widget
            function zle_application_mode_start { echoti smkx }
            function zle_application_mode_stop { echoti rmkx }
            add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
            add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
          fi

          # Enable up/down line search in the command history.

          autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
          zle -N up-line-or-beginning-search
          zle -N down-line-or-beginning-search
          [[ -n "''${key[Up]}"   ]] && bindkey -- "''${key[Up]}"   up-line-or-beginning-search
          [[ -n "''${key[Down]}" ]] && bindkey -- "''${key[Down]}" down-line-or-beginning-search

          # Enable sudo command line editing.
          sudo-command-line() {
              [[ -z $BUFFER ]] && zle up-history
              [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
              zle end-of-line
          }
          zle -N sudo-command-line
          bindkey "\e\e" sudo-command-line
        '';
        shellAliases = {};
        histSize = 1024;
        histFile = "$HOME/.zsh_history";
        setOptions = [
          "HIST_IGNORE_ALL_DUPS"
        ];
      };
    }
    // trace "system shell configuration loaded successfully!" {});
in
  module
