alias ls='/bin/ls --color=auto'
alias la='ls -a --color=auto'
alias fuck='killall -SIGKILL'

set -o vi

HISTSIZE=-1
HISTFILESIZE=-1

bind '"\C-r": " history|sed \"s/^ *[0-9]* *//\"|choice -s \"\" -r \"%k\"|perl -e '\''require \"sys/ioctl.ph\";open(my $f,\"<\",\"/dev/tty\");while(<>){ioctl($f,&TIOCSTI,$_)for split \"\"}'\'';printf "\\\\x1B[2k\\\\r\">/dev/tty\C-j"'

function mcd ()
{
	mkdir -p "$1" && cd "$1"
}

function timer ()
{
    strt=$(date +%s)
    while true ; do
        sec=$(date +%s)
        elaps=$((sec-strt))
        printf "%02d:%02d\r" "$((elaps/60))" "$((elaps%60))"
    done
}

ccd() {
    while true ; do
        SEL="$(find "." -maxdepth 1 | sed '1 a ..' | choice -s "")"
        test "$?" == 2 && break
        test "$SEL" = "." && break
        if [ -d "$SEL" ] ; then
            cd "$SEL"
        elif [ -f "$SEL" ] ; then
            xdg-open "$SEL"
        fi
    done
}
