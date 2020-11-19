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

function! todo#tags#get_all_tags(tag_type)
    " Save the current position
    let l:curPos = getcurpos()

    let l:line = 1
    let l:numLines = line('$')
    let l:tags = {}
    while l:line <= l:numLines
        " Go to line
        call cursor(l:line, 1)
        " Get tags of type at line
        for tag in todo#tags#get_current_tags(a:tag_type)
            let l:tags[tag] = 1
        endfor
        let l:line += 1
    endwhile

    " Go back to original position
    call cursor(l:curPos[1], l:curPos[2])

    return keys(l:tags)
endfunction
