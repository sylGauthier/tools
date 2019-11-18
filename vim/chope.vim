function! chope#grep(str)
    execute 'normal! :silent !grep -rnIH "' . a:str . '" | sed ''s/:/ /'' | choice -s ":" -d $''\e[34m\%k\e[39m: \%v'' > /tmp/vimopen' . "\<CR>"
    let fileCmd = system('cat /tmp/vimopen')
    if empty(fileCmd)
        execute('redraw!')
        echohl WarningMsg | echo "No match found" | echohl None
        return 0
    endif
    let fileName = split(fileCmd, " ")[0]
    let lineNum = split(fileCmd, " ")[1]
    if filereadable(fileName)
        execute "edit +" . lineNum . " " . fileName
    endif
    execute('redraw!')
endfunction

function! chope#grepthis()
    call chope#grep(expand("<cword>"))
endfunction
