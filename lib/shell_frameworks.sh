#!/bin/bash

detect_zsh_frameworks() {
    local frameworks=()

    [ -d "$HOME/.oh-my-zsh" ] && frameworks+=("ohmyzsh")

    [ -d "${ZDOTDIR:-$HOME}/.zprezto" ] && frameworks+=("prezto")

    [ -d "$HOME/.zinit" ] || [ -d "$HOME/.local/share/zinit" ] && frameworks+=("zinit")

    [ -d "$HOME/.zplug" ] && frameworks+=("zplug")

    [ -f "$HOME/.antigen.zsh" ] || [ -d "$HOME/.antigen" ] && frameworks+=("antigen")

    command -v antibody &>/dev/null && frameworks+=("antibody")

    [ -d "$HOME/.zgen" ] && frameworks+=("zgen")

    command -v sheldon &>/dev/null && frameworks+=("sheldon")

    [ -f "$HOME/.p10k.zsh" ] || [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ] && frameworks+=("p10k")

    command -v starship &>/dev/null && frameworks+=("starship")

    [ -d "${ZDOTDIR:-$HOME}/.zsh/pure" ] || [ -f "$HOME/.zsh/pure/pure.zsh" ] && frameworks+=("pure")

    echo "${frameworks[*]}"
}

install_ohmyzsh() {
    log_info "Installing Oh-My-Zsh..."

    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_warn "Oh-My-Zsh is already installed"
        return 0
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_success "Oh-My-Zsh installed successfully"
        return 0
    else
        log_error "Failed to install Oh-My-Zsh"
        return 1
    fi
}

install_prezto() {
    log_info "Installing Prezto..."

    local prezto_dir="${ZDOTDIR:-$HOME}/.zprezto"

    if [ -d "$prezto_dir" ]; then
        log_warn "Prezto is already installed"
        return 0
    fi

    git clone --recursive https://github.com/sorin-ionescu/prezto.git "$prezto_dir"

    setopt EXTENDED_GLOB 2>/dev/null || true
    for rcfile in "${prezto_dir}"/runcoms/^README.md(.N); do
        ln -sf "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}" 2>/dev/null || true
    done

    log_success "Prezto installed successfully"
}

install_zinit() {
    log_info "Installing Zinit..."

    if [ -d "$HOME/.zinit" ] || [ -d "$HOME/.local/share/zinit" ]; then
        log_warn "Zinit is already installed"
        return 0
    fi

    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

    log_success "Zinit installed successfully"
}

install_zplug() {
    log_info "Installing Zplug..."

    if [ -d "$HOME/.zplug" ]; then
        log_warn "Zplug is already installed"
        return 0
    fi

    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

    log_success "Zplug installed successfully"
}

install_antigen() {
    log_info "Installing Antigen..."

    local antigen_dir="$HOME/.antigen"

    if [ -d "$antigen_dir" ] || [ -f "$HOME/.antigen.zsh" ]; then
        log_warn "Antigen is already installed"
        return 0
    fi

    mkdir -p "$antigen_dir"
    curl -L git.io/antigen > "$antigen_dir/antigen.zsh"

    log_success "Antigen installed successfully"
}

install_p10k() {
    log_info "Installing Powerlevel10k..."

    if [ -f "$HOME/.p10k.zsh" ] || [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        log_warn "Powerlevel10k is already installed"
        return 0
    fi

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    log_success "Powerlevel10k installed successfully"
}

install_starship() {
    log_info "Installing Starship..."

    if command -v starship &>/dev/null; then
        log_warn "Starship is already installed"
        return 0
    fi

    curl -sS https://starship.rs/install.sh | sh -s -- -y

    log_success "Starship installed successfully"
}

install_pure() {
    log_info "Installing Pure prompt..."

    local pure_dir="${ZDOTDIR:-$HOME}/.zsh/pure"

    if [ -d "$pure_dir" ] || [ -f "$HOME/.zsh/pure/pure.zsh" ]; then
        log_warn "Pure is already installed"
        return 0
    fi

    mkdir -p "$(dirname "$pure_dir")"
    git clone https://github.com/sindresorhus/pure.git "$pure_dir"

    log_success "Pure prompt installed successfully"
}

configure_ohmyzsh_tokyonight() {
    local variant="${1:-night}"
    local omz_theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
    local theme_file="$omz_theme_dir/tokyonight.zsh-theme"

    mkdir -p "$omz_theme_dir"

    cat > "$theme_file" << 'OMZTHEME'
if [[ "$TOKYONIGHT_VARIANT" == "light" ]]; then
    _tn_blue="#34548a"
    _tn_magenta="#5a4a78"
    _tn_cyan="#0f4b6e"
    _tn_green="#33635c"
    _tn_yellow="#8f5e15"
    _tn_red="#8c4351"
else
    _tn_blue="#7aa2f7"
    _tn_magenta="#bb9af7"
    _tn_cyan="#7dcfff"
    _tn_green="#9ece6a"
    _tn_yellow="#e0af68"
    _tn_red="#f7768e"
fi

PROMPT='%{$fg_bold[blue]%}%n%{$reset_color%}@%{$fg[magenta]%}%m%{$reset_color%}:%{$fg[cyan]%}%~%{$reset_color%}$(git_prompt_info) %# '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

export LS_COLORS="di=38;2;122;162;247:ln=38;2;187;154;247:so=38;2;247;118;142:pi=38;2;224;175;104:ex=38;2;158;206;106:bd=38;2;224;175;104;48;2;26;27;38:cd=38;2;224;175;104;48;2;26;27;38:su=38;2;247;118;142;48;2;26;27;38:sg=38;2;224;175;104;48;2;26;27;38:tw=38;2;26;27;38;48;2;158;206;106:ow=38;2;122;162;247;48;2;26;27;38"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
OMZTHEME

    local zshrc="$HOME/.zshrc"
    if [ -f "$zshrc" ]; then
        sed -i 's/^ZSH_THEME=.*/ZSH_THEME="tokyonight"/' "$zshrc"

        if ! grep -q "TOKYONIGHT_VARIANT" "$zshrc"; then
            sed -i "/^ZSH_THEME=/a export TOKYONIGHT_VARIANT=\"$variant\"" "$zshrc"
        fi
    fi

    log_success "Oh-My-Zsh Tokyo Night theme configured"
}

configure_prezto_tokyonight() {
    local variant="${1:-night}"
    local prezto_dir="${ZDOTDIR:-$HOME}/.zprezto"
    local prompt_dir="$prezto_dir/modules/prompt/functions"

    if [ ! -d "$prezto_dir" ]; then
        log_error "Prezto not found"
        return 1
    fi

    cat > "$prompt_dir/prompt_tokyonight_setup" << 'PREZTOPROMPT'
function prompt_tokyonight_setup {
    setopt LOCAL_OPTIONS
    unsetopt XTRACE KSH_ARRAYS
    prompt_opts=(cr percent sp subst)

    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '%F{green}●%f'
    zstyle ':vcs_info:*' unstagedstr '%F{yellow}●%f'
    zstyle ':vcs_info:*' formats ' %F{cyan}(%b%c%u%F{cyan})%f'
    zstyle ':vcs_info:*' actionformats ' %F{cyan}(%b|%a%c%u%F{cyan})%f'

    add-zsh-hook precmd prompt_tokyonight_precmd
}

function prompt_tokyonight_precmd {
    vcs_info

    PROMPT='%F{#7aa2f7}%n%f@%F{#bb9af7}%m%f:%F{#7dcfff}%~%f${vcs_info_msg_0_} %# '
    RPROMPT='%F{#565f89}%*%f'
}

prompt_tokyonight_setup "$@"
PREZTOPROMPT

    local zpreztorc="${ZDOTDIR:-$HOME}/.zpreztorc"
    if [ -f "$zpreztorc" ]; then
        sed -i "s/zstyle ':prezto:module:prompt' theme.*/zstyle ':prezto:module:prompt' theme 'tokyonight'/" "$zpreztorc"
    fi

    log_success "Prezto Tokyo Night theme configured"
}

configure_zinit_tokyonight() {
    local variant="${1:-night}"
    local zshrc="$HOME/.zshrc"
    local zinit_config="$HOME/.config/tokyo-night/zinit-config.zsh"

    mkdir -p "$(dirname "$zinit_config")"

    cat > "$zinit_config" << 'ZINITCONF'
zinit light zdharma-continuum/fast-syntax-highlighting

zinit light zsh-users/zsh-autosuggestions

zinit light zsh-users/zsh-completions

typeset -gA FAST_HIGHLIGHT_STYLES
FAST_HIGHLIGHT_STYLES[default]='fg=#c0caf5'
FAST_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e'
FAST_HIGHLIGHT_STYLES[reserved-word]='fg=#bb9af7'
FAST_HIGHLIGHT_STYLES[alias]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[suffix-alias]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[builtin]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[function]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[command]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[precommand]='fg=#7dcfff'
FAST_HIGHLIGHT_STYLES[commandseparator]='fg=#ff9e64'
FAST_HIGHLIGHT_STYLES[hashed-command]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[path]='fg=#9ece6a,underline'
FAST_HIGHLIGHT_STYLES[path_prefix]='fg=#9ece6a'
FAST_HIGHLIGHT_STYLES[globbing]='fg=#7dcfff'
FAST_HIGHLIGHT_STYLES[history-expansion]='fg=#bb9af7'
FAST_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ff9e64'
FAST_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ff9e64'
FAST_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#bb9af7'
FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9ece6a'
FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9ece6a'
FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#9ece6a'
FAST_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#7dcfff'
FAST_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#7dcfff'
FAST_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#7dcfff'
FAST_HIGHLIGHT_STYLES[assign]='fg=#c0caf5'
FAST_HIGHLIGHT_STYLES[redirection]='fg=#ff9e64'
FAST_HIGHLIGHT_STYLES[comment]='fg=#565f89'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#565f89'

PROMPT='%F{#7aa2f7}%n%f@%F{#bb9af7}%m%f:%F{#7dcfff}%~%f %# '
ZINITCONF

    if ! grep -q "tokyo-night/zinit-config.zsh" "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# Tokyo Night Zinit Configuration" >> "$zshrc"
        echo "[ -f \"$zinit_config\" ] && source \"$zinit_config\"" >> "$zshrc"
    fi

    log_success "Zinit Tokyo Night configuration created"
}

configure_p10k_tokyonight() {
    local variant="${1:-night}"
    local p10k_file="$HOME/.p10k.zsh"
    local colors_file="$HOME/.config/tokyo-night/p10k-colors.zsh"

    mkdir -p "$(dirname "$colors_file")"

    cat > "$colors_file" << P10KCOLORS
typeset -g POWERLEVEL9K_BACKGROUND=
typeset -g POWERLEVEL9K_FOREGROUND=#c0caf5

typeset -g POWERLEVEL9K_DIR_BACKGROUND=#7aa2f7
typeset -g POWERLEVEL9K_DIR_FOREGROUND=#1a1b26

typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=#9ece6a
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=#1a1b26
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=#e0af68
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=#1a1b26
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=#f7768e
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=#1a1b26

typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=#9ece6a
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=#1a1b26
typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=#f7768e
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=#1a1b26

typeset -g POWERLEVEL9K_TIME_BACKGROUND=#bb9af7
typeset -g POWERLEVEL9K_TIME_FOREGROUND=#1a1b26

typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=#e0af68
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=#1a1b26

typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=#7dcfff
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=#1a1b26

typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=#565f89
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=#c0caf5
P10KCOLORS

    local zshrc="$HOME/.zshrc"
    if ! grep -q "tokyo-night/p10k-colors.zsh" "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# Tokyo Night P10k Colors" >> "$zshrc"
        echo "[ -f \"$colors_file\" ] && source \"$colors_file\"" >> "$zshrc"
    fi

    log_success "P10k Tokyo Night colors installed. You may need to reconfigure p10k for full effect."
}

configure_starship_tokyonight() {
    local variant="${1:-night}"
    local starship_config="$HOME/.config/starship.toml"
    mkdir -p "$(dirname "$starship_config")"

    cat > "$starship_config" << STARSHIPCONF
format = """
[](#7aa2f7)\
\$os\
\$username\
[](bg:#bb9af7 fg:#7aa2f7)\
\$directory\
[](fg:#bb9af7 bg:#9ece6a)\
\$git_branch\
\$git_status\
[](fg:#9ece6a bg:#e0af68)\
\$c\
\$elixir\
\$elm\
\$golang\
\$gradle\
\$haskell\
\$java\
\$julia\
\$nodejs\
\$nim\
\$rust\
\$scala\
\$python\
[](fg:#e0af68 bg:#7dcfff)\
\$docker_context\
[](fg:#7dcfff bg:#565f89)\
\$time\
[ ](fg:#565f89)\
"""

[username]
show_always = true
style_user = "bg:#7aa2f7 fg:#1a1b26"
style_root = "bg:#7aa2f7 fg:#1a1b26"
format = '[\$user ](\$style)'
disabled = false

[os]
style = "bg:#7aa2f7 fg:#1a1b26"
disabled = false

[directory]
style = "bg:#bb9af7 fg:#1a1b26"
format = "[ \$path ](\$style)"
truncation_length = 3
truncation_symbol = ".../"

[directory.substitutions]
"Documents" = " "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[git_branch]
symbol = ""
style = "bg:#9ece6a fg:#1a1b26"
format = '[ \$symbol \$branch ](\$style)'

[git_status]
style = "bg:#9ece6a fg:#1a1b26"
format = '[\$all_status\$ahead_behind ](\$style)'

[nodejs]
symbol = ""
style = "bg:#e0af68 fg:#1a1b26"
format = '[ \$symbol (\$version) ](\$style)'

[rust]
symbol = ""
style = "bg:#e0af68 fg:#1a1b26"
format = '[ \$symbol (\$version) ](\$style)'

[golang]
symbol = ""
style = "bg:#e0af68 fg:#1a1b26"
format = '[ \$symbol (\$version) ](\$style)'

[python]
symbol = ""
style = "bg:#e0af68 fg:#1a1b26"
format = '[ \$symbol (\$version) ](\$style)'

[docker_context]
symbol = ""
style = "bg:#7dcfff fg:#1a1b26"
format = '[ \$symbol \$context ](\$style)'

[time]
disabled = false
time_format = "%R"
style = "bg:#565f89 fg:#c0caf5"
format = '[ \$time ](\$style)'
STARSHIPCONF

    local zshrc="$HOME/.zshrc"
    if ! grep -q 'eval "$(starship init zsh)"' "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# Starship prompt" >> "$zshrc"
        echo 'eval "$(starship init zsh)"' >> "$zshrc"
    fi

    log_success "Starship Tokyo Night theme installed"
}

configure_pure_tokyonight() {
    local variant="${1:-night}"
    local colors_file="$HOME/.config/tokyo-night/pure-colors.zsh"
    mkdir -p "$(dirname "$colors_file")"

    cat > "$colors_file" << PURECOLORS
zstyle :prompt:pure:path color '#7aa2f7'
zstyle :prompt:pure:git:branch color '#bb9af7'
zstyle :prompt:pure:git:dirty color '#f7768e'
zstyle :prompt:pure:git:arrow color '#7dcfff'
zstyle :prompt:pure:git:stash color '#e0af68'
zstyle :prompt:pure:git:fetch color '#565f89'
zstyle :prompt:pure:git:action color '#ff9e64'
zstyle :prompt:pure:prompt:error color '#f7768e'
zstyle :prompt:pure:prompt:success color '#9ece6a'
zstyle :prompt:pure:prompt:continuation color '#565f89'
zstyle :prompt:pure:user color '#7dcfff'
zstyle :prompt:pure:host color '#bb9af7'
zstyle :prompt:pure:virtualenv color '#e0af68'
PURECOLORS

    local zshrc="$HOME/.zshrc"

    if ! grep -q "fpath+=.*pure" "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# Pure prompt" >> "$zshrc"
        echo "fpath+=(${ZDOTDIR:-$HOME}/.zsh/pure)" >> "$zshrc"
        echo "autoload -U promptinit; promptinit" >> "$zshrc"
        echo "prompt pure" >> "$zshrc"
    fi

    if ! grep -q "tokyo-night/pure-colors.zsh" "$zshrc" 2>/dev/null; then
        echo "" >> "$zshrc"
        echo "# Tokyo Night Pure Colors" >> "$zshrc"
        echo "[ -f \"$colors_file\" ] && source \"$colors_file\"" >> "$zshrc"
    fi

    log_success "Pure Tokyo Night theme installed"
}

detect_fish_frameworks() {
    local frameworks=()

    [ -d "$HOME/.local/share/omf" ] && frameworks+=("omf")

    [ -f "$HOME/.config/fish/functions/fisher.fish" ] && frameworks+=("fisher")

    [ -f "$HOME/.config/fish/functions/_tide_item_pwd.fish" ] && frameworks+=("tide")

    [ -f "$HOME/.config/fish/functions/fundle.fish" ] && frameworks+=("fundle")

    echo "${frameworks[*]}"
}

install_omf() {
    log_info "Installing Oh-My-Fish..."

    if [ -d "$HOME/.local/share/omf" ]; then
        log_warn "Oh-My-Fish is already installed"
        return 0
    fi

    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

    log_success "Oh-My-Fish installed successfully"
}

install_fisher() {
    log_info "Installing Fisher..."

    if [ -f "$HOME/.config/fish/functions/fisher.fish" ]; then
        log_warn "Fisher is already installed"
        return 0
    fi

    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

    log_success "Fisher installed successfully"
}

install_tide() {
    log_info "Installing Tide prompt..."

    if [ ! -f "$HOME/.config/fish/functions/fisher.fish" ]; then
        install_fisher
    fi

    fish -c "fisher install IlanCosman/tide@v6"

    log_success "Tide prompt installed successfully"
}

configure_fish_tokyonight() {
    local variant="${1:-night}"
    local fish_conf="$HOME/.config/fish/conf.d/tokyo-night.fish"

    mkdir -p "$(dirname "$fish_conf")"

    cat > "$fish_conf" << 'FISHTHEME'
set -gx TOKYONIGHT_VARIANT "__VARIANT__"

switch $TOKYONIGHT_VARIANT
    case night storm
        set -U fish_color_normal c0caf5
        set -U fish_color_command 7aa2f7
        set -U fish_color_keyword bb9af7
        set -U fish_color_quote 9ece6a
        set -U fish_color_redirection 7dcfff
        set -U fish_color_end ff9e64
        set -U fish_color_error f7768e
        set -U fish_color_param c0caf5
        set -U fish_color_comment 565f89
        set -U fish_color_selection --background=33467c
        set -U fish_color_search_match --background=33467c
        set -U fish_color_operator 9ece6a
        set -U fish_color_escape bb9af7
        set -U fish_color_autosuggestion 565f89
        set -U fish_pager_color_progress 565f89
        set -U fish_pager_color_prefix 7dcfff
        set -U fish_pager_color_completion c0caf5
        set -U fish_pager_color_description 565f89
    case light
        set -U fish_color_normal 343b58
        set -U fish_color_command 34548a
        set -U fish_color_keyword 5a4a78
        set -U fish_color_quote 33635c
        set -U fish_color_redirection 0f4b6e
        set -U fish_color_end 965027
        set -U fish_color_error 8c4351
        set -U fish_color_param 343b58
        set -U fish_color_comment 9699a3
        set -U fish_color_selection --background=99a7df
        set -U fish_color_search_match --background=99a7df
        set -U fish_color_operator 33635c
        set -U fish_color_escape 5a4a78
        set -U fish_color_autosuggestion 9699a3
end
FISHTHEME

    sed -i "s/__VARIANT__/$variant/" "$fish_conf"

    log_success "Fish Tokyo Night theme configured"
}

configure_tide_tokyonight() {
    local variant="${1:-night}"

    if [ ! -f "$HOME/.config/fish/functions/_tide_item_pwd.fish" ]; then
        log_warn "Tide not installed, installing..."
        install_tide
    fi

    fish -c "
        set -U tide_pwd_color_dirs 7aa2f7
        set -U tide_pwd_color_anchors 7dcfff
        set -U tide_git_color_branch 9ece6a
        set -U tide_git_color_conflicted f7768e
        set -U tide_git_color_dirty e0af68
        set -U tide_git_color_operation f7768e
        set -U tide_git_color_staged 9ece6a
        set -U tide_git_color_stash bb9af7
        set -U tide_git_color_untracked 7dcfff
        set -U tide_git_color_upstream 9ece6a
        set -U tide_cmd_duration_color e0af68
        set -U tide_context_color_default 7dcfff
        set -U tide_context_color_root f7768e
        set -U tide_context_color_ssh e0af68
        set -U tide_jobs_color 9ece6a
        set -U tide_status_color 9ece6a
        set -U tide_status_color_failure f7768e
        set -U tide_time_color 565f89
    "

    log_success "Tide Tokyo Night colors configured"
}

detect_bash_frameworks() {
    local frameworks=()

    [ -d "$HOME/.bash_it" ] && frameworks+=("bashit")

    [ -d "$HOME/.oh-my-bash" ] && frameworks+=("ohmybash")

    [ -f "$HOME/.bash-powerline.sh" ] && frameworks+=("powerline")

    echo "${frameworks[*]}"
}

install_bashit() {
    log_info "Installing Bash-it..."

    if [ -d "$HOME/.bash_it" ]; then
        log_warn "Bash-it is already installed"
        return 0
    fi

    git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
    ~/.bash_it/install.sh --silent

    log_success "Bash-it installed successfully"
}

install_ohmybash() {
    log_info "Installing Oh-My-Bash..."

    if [ -d "$HOME/.oh-my-bash" ]; then
        log_warn "Oh-My-Bash is already installed"
        return 0
    fi

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended

    log_success "Oh-My-Bash installed successfully"
}

configure_bashit_tokyonight() {
    local variant="${1:-night}"
    local bashit_theme_dir="$HOME/.bash_it/themes/tokyonight"

    if [ ! -d "$HOME/.bash_it" ]; then
        log_error "Bash-it not found"
        return 1
    fi

    mkdir -p "$bashit_theme_dir"

    cat > "$bashit_theme_dir/tokyonight.theme.bash" << 'BASHITTHEME'
function prompt_command() {
    local exit_code=$?

    local git_info=""
    if git rev-parse --git-dir &>/dev/null; then
        local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
        local dirty=""
        [[ -n $(git status --porcelain 2>/dev/null) ]] && dirty="*"
        git_info=" git:(${branch}${dirty})"
    fi

    local exit_indicator="➜"
    [[ $exit_code -ne 0 ]] && exit_indicator="➜"

    PS1="\u@\h:\w${git_info} ${exit_indicator} "
}

safe_append_prompt_command prompt_command

export LS_COLORS="di=38;2;122;162;247:ln=38;2;187;154;247:so=38;2;247;118;142:pi=38;2;224;175;104:ex=38;2;158;206;106:bd=38;2;224;175;104;48;2;26;27;38:cd=38;2;224;175;104;48;2;26;27;38:su=38;2;247;118;142;48;2;26;27;38:sg=38;2;224;175;104;48;2;26;27;38:tw=38;2;26;27;38;48;2;158;206;106:ow=38;2;122;162;247;48;2;26;27;38"
BASHITTHEME

    local bashrc="$HOME/.bashrc"
    if [ -f "$bashrc" ]; then
        sed -i "s/export BASH_IT_THEME=.*/export BASH_IT_THEME='tokyonight'/" "$bashrc"
    fi

    log_success "Bash-it Tokyo Night theme configured"
}

configure_ohmybash_tokyonight() {
    local variant="${1:-night}"
    local omb_theme_dir="$HOME/.oh-my-bash/custom/themes/tokyonight"

    if [ ! -d "$HOME/.oh-my-bash" ]; then
        log_error "Oh-My-Bash not found"
        return 1
    fi

    mkdir -p "$omb_theme_dir"

    cat > "$omb_theme_dir/tokyonight.theme.sh" << 'OMBTHEME'
function _omb_theme_PROMPT_COMMAND() {
    local exit_code=$?

    local git_info=""
    if _omb_prompt_git; then
        git_info=" $(git_prompt_info)"
    fi

    local exit_indicator="❯"
    [[ $exit_code -ne 0 ]] && exit_indicator="❯"

    PS1="\u@\h:\w${git_info} ${exit_indicator} "
}

_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND

export LS_COLORS="di=38;2;122;162;247:ln=38;2;187;154;247:so=38;2;247;118;142:pi=38;2;224;175;104:ex=38;2;158;206;106"
OMBTHEME

    local bashrc="$HOME/.bashrc"
    if [ -f "$bashrc" ]; then
        sed -i "s/OSH_THEME=.*/OSH_THEME=\"tokyonight\"/" "$bashrc"
    fi

    log_success "Oh-My-Bash Tokyo Night theme configured"
}

show_framework_selection_gui() {
    local shell_type="$1"
    local gui_cmd="zenity"
    command -v yad &>/dev/null && gui_cmd="yad"

    case "$shell_type" in
        zsh)
            local detected=$(detect_zsh_frameworks)
            local options=""

            [[ "$detected" == *"ohmyzsh"* ]] && options+="FALSE ohmyzsh_config Configure_Oh-My-Zsh "
            [[ "$detected" == *"prezto"* ]] && options+="FALSE prezto_config Configure_Prezto "
            [[ "$detected" == *"zinit"* ]] && options+="FALSE zinit_config Configure_Zinit "
            [[ "$detected" == *"p10k"* ]] && options+="FALSE p10k_config Configure_Powerlevel10k "
            [[ "$detected" == *"starship"* ]] && options+="FALSE starship_config Configure_Starship "
            [[ "$detected" == *"pure"* ]] && options+="FALSE pure_config Configure_Pure "

            [[ "$detected" != *"ohmyzsh"* ]] && options+="FALSE ohmyzsh_install Install_Oh-My-Zsh "
            [[ "$detected" != *"prezto"* ]] && options+="FALSE prezto_install Install_Prezto "
            [[ "$detected" != *"zinit"* ]] && options+="FALSE zinit_install Install_Zinit "
            [[ "$detected" != *"zplug"* ]] && options+="FALSE zplug_install Install_Zplug "
            [[ "$detected" != *"antigen"* ]] && options+="FALSE antigen_install Install_Antigen "
            [[ "$detected" != *"p10k"* ]] && options+="FALSE p10k_install Install_Powerlevel10k "
            [[ "$detected" != *"starship"* ]] && options+="FALSE starship_install Install_Starship "
            [[ "$detected" != *"pure"* ]] && options+="FALSE pure_install Install_Pure "

            options="TRUE standard Standard_ZSH_prompt $options"

            zenity --list \
                --title="ZSH Framework Selection" \
                --text="Select ZSH framework to install/configure:\n\nDetected: ${detected:-none}" \
                --radiolist \
                --column="Select" --column="Action" --column="Description" \
                $options \
                --width=500 --height=450 \
                --print-column=2 2>/dev/null
            ;;

        fish)
            local detected=$(detect_fish_frameworks)
            local options=""

            [[ "$detected" == *"omf"* ]] && options+="FALSE omf_config Configure_Oh-My-Fish "
            [[ "$detected" == *"fisher"* ]] && options+="FALSE fisher_config Configure_Fisher "
            [[ "$detected" == *"tide"* ]] && options+="FALSE tide_config Configure_Tide "

            [[ "$detected" != *"omf"* ]] && options+="FALSE omf_install Install_Oh-My-Fish "
            [[ "$detected" != *"fisher"* ]] && options+="FALSE fisher_install Install_Fisher "
            [[ "$detected" != *"tide"* ]] && options+="FALSE tide_install Install_Tide_Prompt "

            options="TRUE standard Standard_Fish_theme $options"

            zenity --list \
                --title="Fish Framework Selection" \
                --text="Select Fish framework to install/configure:\n\nDetected: ${detected:-none}" \
                --radiolist \
                --column="Select" --column="Action" --column="Description" \
                $options \
                --width=500 --height=400 \
                --print-column=2 2>/dev/null
            ;;

        bash)
            local detected=$(detect_bash_frameworks)
            local options=""

            [[ "$detected" == *"bashit"* ]] && options+="FALSE bashit_config Configure_Bash-it "
            [[ "$detected" == *"ohmybash"* ]] && options+="FALSE ohmybash_config Configure_Oh-My-Bash "

            [[ "$detected" != *"bashit"* ]] && options+="FALSE bashit_install Install_Bash-it "
            [[ "$detected" != *"ohmybash"* ]] && options+="FALSE ohmybash_install Install_Oh-My-Bash "

            options="TRUE standard Standard_Bash_prompt $options"

            zenity --list \
                --title="Bash Framework Selection" \
                --text="Select Bash framework to install/configure:\n\nDetected: ${detected:-none}" \
                --radiolist \
                --column="Select" --column="Action" --column="Description" \
                $options \
                --width=500 --height=400 \
                --print-column=2 2>/dev/null
            ;;
    esac
}

process_framework_selection() {
    local selection="$1"
    local variant="${2:-night}"

    case "$selection" in
        ohmyzsh_install)
            install_ohmyzsh && configure_ohmyzsh_tokyonight "$variant"
            ;;
        ohmyzsh_config)
            configure_ohmyzsh_tokyonight "$variant"
            ;;
        prezto_install)
            install_prezto && configure_prezto_tokyonight "$variant"
            ;;
        prezto_config)
            configure_prezto_tokyonight "$variant"
            ;;
        zinit_install)
            install_zinit && configure_zinit_tokyonight "$variant"
            ;;
        zinit_config)
            configure_zinit_tokyonight "$variant"
            ;;
        zplug_install)
            install_zplug
            ;;
        antigen_install)
            install_antigen
            ;;
        p10k_install)
            install_p10k && configure_p10k_tokyonight "$variant"
            ;;
        p10k_config)
            configure_p10k_tokyonight "$variant"
            ;;
        starship_install)
            install_starship && configure_starship_tokyonight "$variant"
            ;;
        starship_config)
            configure_starship_tokyonight "$variant"
            ;;
        pure_install)
            install_pure && configure_pure_tokyonight "$variant"
            ;;
        pure_config)
            configure_pure_tokyonight "$variant"
            ;;
        omf_install)
            install_omf && configure_fish_tokyonight "$variant"
            ;;
        fisher_install)
            install_fisher && configure_fish_tokyonight "$variant"
            ;;
        tide_install)
            install_tide && configure_tide_tokyonight "$variant"
            ;;
        omf_config|fisher_config)
            configure_fish_tokyonight "$variant"
            ;;
        tide_config)
            configure_tide_tokyonight "$variant"
            ;;
        bashit_install)
            install_bashit && configure_bashit_tokyonight "$variant"
            ;;
        bashit_config)
            configure_bashit_tokyonight "$variant"
            ;;
        ohmybash_install)
            install_ohmybash && configure_ohmybash_tokyonight "$variant"
            ;;
        ohmybash_config)
            configure_ohmybash_tokyonight "$variant"
            ;;
        standard|*)
            return 0
            ;;
    esac
}

set_default_shell() {
    local shell_name="$1"
    local shell_path=""

    case "$shell_name" in
        zsh)
            shell_path=$(which zsh 2>/dev/null)
            ;;
        fish)
            shell_path=$(which fish 2>/dev/null)
            ;;
        bash)
            shell_path=$(which bash 2>/dev/null)
            ;;
        *)
            log_error "Unknown shell: $shell_name"
            return 1
            ;;
    esac

    if [ -z "$shell_path" ]; then
        log_error "$shell_name is not installed"
        return 1
    fi

    if ! grep -q "^$shell_path$" /etc/shells 2>/dev/null; then
        log_warn "$shell_path not in /etc/shells, attempting to add..."
        echo "$shell_path" | sudo tee -a /etc/shells >/dev/null
    fi

    log_info "Changing default shell to $shell_name..."
    chsh -s "$shell_path"

    if [ $? -eq 0 ]; then
        log_success "Default shell changed to $shell_name"
        log_info "Please log out and back in for the change to take effect"
    else
        log_error "Failed to change default shell"
        return 1
    fi
}

show_shell_change_dialog() {
    local current_shell=$(basename "$SHELL")
    local available_shells=""

    command -v bash &>/dev/null && available_shells+="FALSE bash Bash "
    command -v zsh &>/dev/null && available_shells+="FALSE zsh ZSH "
    command -v fish &>/dev/null && available_shells+="FALSE fish Fish "

    available_shells=$(echo "$available_shells" | sed "s/FALSE $current_shell/TRUE $current_shell/")

    local selected
    selected=$(zenity --list \
        --title="Change Default Shell" \
        --text="Select your default shell:\n\nCurrent: $current_shell" \
        --radiolist \
        --column="Select" --column="Shell" --column="Name" \
        $available_shells \
        FALSE keep "Keep current ($current_shell)" \
        --width=400 --height=300 \
        --print-column=2 2>/dev/null)

    if [ -n "$selected" ] && [ "$selected" != "keep" ] && [ "$selected" != "$current_shell" ]; then
        set_default_shell "$selected"
    fi
}
