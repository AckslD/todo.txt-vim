" Opens a file related to the task, using the provided key
" If the file does not exist a new one is created, prompting
" the user for a filename. If no input is given the current
" date and time is used for folder and name.
function! todo#files#open(key, defaultPath, defaultExt)
    let l:filename = todo#todokeys#get(a:key)
    if l:filename ==# -1
        let l:timeFormat = "%Y/%m/%d/%H%M%S"
        let l:defaultFilename = a:defaultPath . strftime(l:timeFormat) . a:defaultExt
        let l:filename = input("Enter new filename (default " . l:defaultFilename . "): ")
        if strlen(l:filename) ==# 0
            let l:filename = l:defaultFilename
        endif
        call todo#todokeys#set(a:key, l:filename)
        " TODO should we write, what about other changes
        " Needed for now to open the new edit
        write
        " Create the folders if they don't exists
    endif
    execute "vsplit" l:filename
    call system("mkdir -p " . expand("%:h"))
endfunction
