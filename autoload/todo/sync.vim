function! todo#sync#push()
    call system("rclone copy " . g:todo_root_folder . " remote:/todo")
    echo "Todo folder pushed"
endfunction

function! todo#sync#pull()
    let l:cmd = "rclone copy remote:/todo " . g:todo_root_folder
    call system(l:cmd)
    echo "Todo folder pulled"
endfunction

function! todo#sync#diff(filename)
    if strlen(a:filename) ==# 0
        let l:filename = "todo.txt"
    else
        let l:filename = a:filename
    endif
    let l:localFile = g:todo_root_folder . "/" . l:filename
    let l:remoteFile = "remote:/todo/" . l:filename
    let l:cmd = "diff " . l:localFile . " <(rclone cat " . l:remoteFile . ")"
    echo l:cmd
    call DedicatedTerminal("todo", l:cmd, "tabnew")
endfunction
