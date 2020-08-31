function! todo#sync#push()
    call system("rclone sync ~/todo remote:/todo")
    echo "Todo folder pushed"
endfunction

function! todo#sync#pull()
    let l:cmd = "rclone sync remote:/todo ~/todo"
    call system(l:cmd)
    " call DedicatedTerminal("todo", l:cmd, "vsplit")
    echo "Todo folder pulled"
endfunction

function! todo#sync#diff(filename)
    let l:localFile = "~/todo/" . a:filename
    let l:remoteFile = "remote:/todo/" . a:filename
    let l:cmd = "diff " . l:localFile . " <(rclone cat " . l:remoteFile . ")"
    echo l:cmd
    call DedicatedTerminal("todo", l:cmd, "tabnew")
endfunction
