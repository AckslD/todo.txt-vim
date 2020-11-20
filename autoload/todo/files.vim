" Opens a file related to the task, using the provided key
" If the file does not exist a new one is created, prompting
" the user for a filename. If no input is given the current
" date and time is used for folder and name.
function! todo#files#open(key, defaultDir, defaultExt)
    let l:filepath = todo#todokeys#get(a:key)
    if l:filepath ==# -1
        " Get path
        let l:defaultDir = a:defaultDir . strftime("%Y/%m/%d/")
        let l:dir = input("Enter folder (default " . l:defaultDir . "): ")
        if strlen(l:dir) ==# 0
            let l:dir = l:defaultDir
        endif
        " Get filename
        let l:defaultFilename = strftime("%H%M%S") . a:defaultExt
        let l:filename = input("Enter filename (default " . l:defaultFilename . "): ")
        if strlen(l:filename) ==# 0
            let l:filename = l:defaultFilename
        endif
        " Add default extension if none given
        if match(l:filename, ".*\\..*") == -1
            let l:filename = l:filename . a:defaultExt
        endif
        let l:filepath = l:dir . l:filename
        call todo#todokeys#set(a:key, l:filepath)
        " TODO should we write, what about other changes
        " Needed for now to open the new edit
        write
    endif
    execute "vsplit" l:filepath
    " Create the folders if they don't exists
    call system("mkdir -p " . expand("%:h"))
endfunction
