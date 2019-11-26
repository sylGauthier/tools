alias ls='/bin/ls --color=auto'
alias la='ls -a --color=auto'
alias fuck='killall -SIGKILL'

set -o vi

HISTSIZE=-1
HISTFILESIZE=-1

bind -x '"\C-r": history|tac|sed "s/^ *[0-9]* *//"|(printf "\\x1b\\x5b\\x34\\x7e\\x15";choice -s "" -r "%k" -S "$READLINE_LINE")|perl -e "open(my \$f,\"<\",\"/dev/tty\");while(<>){ioctl(\$f,0x5412,\$_)for split \"\"}"'

export OPENER=rifle

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
        SEL="$(find "." -maxdepth 1 | sort | sed '1 a ..' | choice -s "")"
        test "$?" == 2 && break
        test "$SEL" = "." && break
        if [ -d "$SEL" ] ; then
            cd "$SEL"
        elif [ -f "$SEL" ] ; then
            $OPENER "$SEL"
        fi
    done
}
