" Opens a file related to the task, using the provided key
" If the file does not exist a new one is created, prompting
" the user for a filename. If no input is given the current
" date and time is used for folder and name.
function! todo#files#open(key, defaultDir, defaultExt)
    let l:filepath = todo#todokeys#get(a:key)
    if l:filepath ==# -1
        let l:answer = inputlist([
            \ "No note linked, what do you want to do?:",
            \ "1. Create a new one",
            \ "2. Add an existing note",
            \])
        if l:answer ==# 0
            return
        elseif l:answer ==# 1
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
            call todo#files#handle_open(a:key, l:filepath)
        elseif l:answer ==# 2
            " fzf will call the handler so return after
            call todo#files#choose_existing(a:key, a:defaultDir)
        else
            echoerr "Unknown input"
        endif
    else
        execute "vsplit" l:filepath
    endif
endfunction

function! todo#files#handle_open(key, filepath)
    call todo#todokeys#set(a:key, a:filepath)
    execute "vsplit" a:filepath
    " Create the folders if they don't exists
    call system("mkdir -p " . expand("%:h"))
endfunction

function! todo#files#choose_existing(key, defaultDir)
    call fzf#run({
        \ 'source': 'find ~/.notes -type f -name "[!.]*"',
        \ 'sink': function('todo#files#handle_open', [a:key]),
        \})
endfunction
