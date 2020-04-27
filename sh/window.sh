window_title() {
    printf '\e]0;%s\a' "$1"
}
