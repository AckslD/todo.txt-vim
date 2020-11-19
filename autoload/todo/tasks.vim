" Inserts new task
" `mode` should be 'n' or 'i' indicating the current mode
" `above` should be 1 (new task above) or 0 (new task below)
" `copy_tags` should be 1 (new task with same tags a current) or 0 (new blank task)
function! todo#tasks#insert_new(mode, above, copy_tags)
    if a:mode ==# "i"
        execute "normal! \<esc>"
    endif

    if a:copy_tags
        let l:tags = todo#tags#get_current_tags("context") + todo#tags#get_current_tags("project")
    endif

    if a:above
        execute "normal! O"
    else
        execute "normal! o"
    endif
    execute "normal! \<esc>i(A) " . strftime("%Y-%m-%d") . " "
    if a:copy_tags
        call setline('.', getline('.') . " " . join(l:tags, ' '))
    endif

    execute "normal! l"
    startinsert
endfunction
