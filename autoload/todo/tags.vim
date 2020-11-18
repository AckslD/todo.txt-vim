" Returns the project or context tags of the current line as a list
function! todo#tags#get_current_tags(tag_type)
    if a:tag_type ==# "project"
        let l:prefix = "+"
    elseif a:tag_type ==# "context"
        let l:prefix = "@"
    else
        echoerr "Unknown tag type: " . a:tag_type
        return
    endif
    let l:regex="\\s\\zs" . l:prefix . "\\S\\+\\ze\\(\\s\\|\\n\\)"
    let l:motion="e"
    return todo#parse#get_elements(l:regex, l:motion)
endfunction
