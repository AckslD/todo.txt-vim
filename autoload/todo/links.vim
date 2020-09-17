function! todo#links#open()
    let l:link = todo#todokeys#get("link")
    if l:link !=# -1
        echo system("xdg-open " . l:link)
    endif
endfunction
