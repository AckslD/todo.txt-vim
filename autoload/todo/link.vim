function! todo#link#open()
    let l:link = todo#todokeys#get("link")
    if l:link ==# -1
        let l:link = input("No existing link, enter one to add (empty cancels): ")
        if strlen(l:link) ==# 0
            return
        endif
        call todo#todokeys#set("link", l:link)
    endif
    echo system("xdg-open " . l:link)
endfunction

function! todo#link#pop()
    call todo#todokeys#pop("link")
endfunction
