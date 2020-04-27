#/bin/bash

#Colors:
#0: Black
#1: Red
#2: Green
#3: Yellow
#4: Blue
#5: Magenta
#6: Cyan
#7: White

reset () {
    printf '\x1b[0m'
}

set_bold () {
    printf '\x1b[1m'
}
reset_bold () {
    printf '\x1b[22m'
}

set_bg () {
    printf '\x1b['$((40+$1))"$2"'m'
}
reset_bg () {
    printf '\x1b[49m'
}

set_fg () {
    printf '\x1b['$((30+$1))"$2"'m'
}
reset_fg () {
    printf '\x1b[39m'
}

reset_colors () {
    reset_fg; reset_bg
}

print_sep () {
    printf '\ue0b0'
}

next_segment () {
    if [ ! -z "$_PROMPT_BG" ]; then
        set_fg $_PROMPT_BG; set_bg $@; reset_bold; print_sep
    fi
    set_bg $@; _PROMPT_BG="$@"
}

prompt_cmd_result () {
    if [ $RET -ne 0 ]; then
        set_fg 1; printf '✘'; reset_fg
        return 1
    fi
    return 0
}

prompt_is_root () {
    if [ $UID -eq 0 ]; then
        set_fg 3; printf '⚡'; reset_fg
        return 1
    fi
    return 0
}

prompt_has_bg_jobs () {
    if [ $(jobs -l | wc -l) -gt 0 ]; then
        set_fg 2; printf '⚙'; reset_fg
        return 1
    fi
    return 0
}

prompt_status_icons () {
    next_segment 8 ';2;0;0;0'; set_bold
    prompt_cmd_result;
    #prompt_is_root;
    #prompt_has_bg_jobs;
}

prompt_context () {
    next_segment 6; set_bold
    set_fg 0; printf ' \\u'
    set_fg 0; printf '@'
    set_fg 0; printf '\\h '
}

prompt_curdir () {
    next_segment 4; set_bold
    set_fg 7; printf ' \\w '
}

prompt_git () {
    local ref mode
    local repo_path=$(git rev-parse --git-dir 2>/dev/null)
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
        if [ $(git status --porcelain | wc -l) -gt 0 ]; then
            next_segment 3
        else
            next_segment 2
        fi
        set_bold; set_fg 0
        if [[ -e "$repo_path/BISECT_LOG" ]]; then
            mode=" <B>"
        elif [[ -e "$repo_path/MERGE_HEAD" ]]; then
            mode=" >M<"
        elif [[ -e "$repo_path/rebase" || -e "$repo_path/rebase-apply" || -e "$repo_path/rebase-merge" || -e "$repo_path/../.dotest" ]]; then
            mode=" >R>"
        fi
        printf ' '"$(echo "$ref" | sed 's/refs\/heads\//\\ue0a0 /')"$mode' '
    fi
}

prompt_end () {
    next_segment 9
    reset; printf '\\n\\$ '
}

get_ps1 () {
    local RET=$?
    reset
    prompt_status_icons
    prompt_context
    prompt_curdir
    prompt_git
    prompt_end
}

set_ps1 () {
    PS1="$(get_ps1)"
}
