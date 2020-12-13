" File:        todo.txt.vim
" Description: Todo.txt filetype detection
" Author:      Leandro Freitas <freitass@gmail.com>
" License:     Vim license
" Website:     http://github.com/freitass/todo.txt-vim
" Version:     0.4

" Save context {{{1
let s:save_cpo = &cpo
set cpo&vim

" General options {{{1
" Some options lose their values when window changes. They will be set every
" time this script is invocated, which is whenever a file of this type is
" created or edited.
setlocal textwidth=0
setlocal wrapmargin=0

" Settings {{{1
if ! exists("g:todo_root_folder")
    let g:todo_root_folder = "~/todo"
endif

" Mappings {{{1
" Sort tasks {{{2
nnoremap <script> <silent> <buffer> <localleader>s :%sort<CR>
vnoremap <script> <silent> <buffer> <localleader>s :sort<CR>
nnoremap <script> <silent> <buffer> <localleader>s@ :%call todo#txt#sort_by_context()<CR>
vnoremap <script> <silent> <buffer> <localleader>s@ :call todo#txt#sort_by_context()<CR>
nnoremap <script> <silent> <buffer> <localleader>s+ :%call todo#txt#sort_by_project()<CR>
vnoremap <script> <silent> <buffer> <localleader>s+ :call todo#txt#sort_by_project()<CR>
nnoremap <script> <silent> <buffer> <localleader>sd :%call todo#txt#sort_by_date()<CR>
vnoremap <script> <silent> <buffer> <localleader>sd :call todo#txt#sort_by_date()<CR>
nnoremap <script> <silent> <buffer> <localleader>sdd :%call todo#txt#sort_by_due_date()<CR>
vnoremap <script> <silent> <buffer> <localleader>sdd :call todo#txt#sort_by_due_date()<CR>

" Change priority {{{2
nnoremap <script> <silent> <buffer> <localleader>j :call todo#txt#prioritize_increase()<CR>
vnoremap <script> <silent> <buffer> <localleader>j :call todo#txt#prioritize_increase()<CR>
nnoremap <script> <silent> <buffer> <localleader>k :call todo#txt#prioritize_decrease()<CR>
vnoremap <script> <silent> <buffer> <localleader>k :call todo#txt#prioritize_decrease()<CR>
nnoremap <script> <silent> <buffer> <localleader>a :call todo#txt#prioritize_add('A')<CR>
vnoremap <script> <silent> <buffer> <localleader>a :call todo#txt#prioritize_add('A')<CR>
nnoremap <script> <silent> <buffer> <localleader>b :call todo#txt#prioritize_add('B')<CR>
vnoremap <script> <silent> <buffer> <localleader>b :call todo#txt#prioritize_add('B')<CR>
nnoremap <script> <silent> <buffer> <localleader>c :call todo#txt#prioritize_add('C')<CR>
vnoremap <script> <silent> <buffer> <localleader>c :call todo#txt#prioritize_add('C')<CR>

" Insert date {{{2
" inoremap <script> <silent> <buffer> date<Tab> <C-R>=strftime("%Y-%m-%d")<CR>
nnoremap <script> <silent> <buffer> <localleader>d :call todo#date#pick_date()<CR>
" nnoremap <script> <silent> <buffer> <localleader>d :call todo#txt#replace_date()<CR>
" vnoremap <script> <silent> <buffer> <localleader>d :call todo#txt#replace_date()<CR>

" Mark done {{{2
nnoremap <script> <silent> <buffer> <localleader>x :call todo#txt#mark_as_done()<CR>
vnoremap <script> <silent> <buffer> <localleader>x :call todo#txt#mark_as_done()<CR>

" Mark all done {{{2
nnoremap <script> <silent> <buffer> <localleader>X :call todo#txt#mark_all_as_done()<CR>

" Remove completed {{{2
nnoremap <script> <silent> <buffer> <localleader>D :call todo#txt#remove_completed()<CR>

" Notes {{{2
nnoremap <script> <silent> <buffer> <localleader>no :call todo#note#open()<CR>
nnoremap <script> <silent> <buffer> <localleader>nd :call todo#note#pop()<CR>

" Subtasks {{{2
nnoremap <script> <silent> <buffer> <localleader>to :call todo#subtasks#open()<CR>
nnoremap <script> <silent> <buffer> <localleader>td :call todo#subtasks#pop()<CR>

" Links {{{2
nnoremap <script> <silent> <buffer> <localleader>lo :call todo#link#open()<CR>
nnoremap <script> <silent> <buffer> <localleader>ld :call todo#link#pop()<CR>

" Key values {{{2
nnoremap <script> <silent> <buffer> <localleader>vd :call todo#todokeys#pop("")<CR>

" Tasks {{{2
nnoremap <script> <silent> <buffer> <localleader>o :call todo#tasks#insert_new("n", 0, 0)<CR>
nnoremap <script> <silent> <buffer> <localleader>O :call todo#tasks#insert_new("n", 1, 0)<CR>
nnoremap <script> <silent> <buffer> <localleader>p :call todo#tasks#insert_new("n", 0, 1)<CR>
nnoremap <script> <silent> <buffer> <localleader>P :call todo#tasks#insert_new("n", 1, 1)<CR>
inoremap <script> <silent> <buffer> <m-o> <esc>:call todo#tasks#insert_new("i", 0, 0)<CR>
inoremap <script> <silent> <buffer> <m-p> <esc>:call todo#tasks#insert_new("i", 0, 1)<CR>

" Folding {{{2
nnoremap <script> <silent> <buffer> <localleader>zp :call todo#folding#toggle_focus_project()<CR>
nnoremap <script> <silent> <buffer> <localleader>zc :call todo#folding#toggle_focus_context()<CR>
nnoremap <script> <silent> <buffer> <localleader>zd :call todo#folding#toggle_focus_due_date()<CR>
nnoremap <script> <silent> <buffer> <localleader>zt :call todo#folding#focus_query_tag()<CR>

" Folding {{{1
" Options {{{2
setlocal foldmethod=expr
setlocal foldexpr=todo#folding#foldlevel(v:lnum)
setlocal foldtext=s:todo_fold_text()
setlocal fml=0

" s:todo_fold_text() {{{2
function! s:todo_fold_text()
    " The text displayed at the fold is formatted as '+- N Completed tasks'
    " where N is the number of lines folded.
    return '+' . v:folddashes . ' '
                \ . (v:foldend - v:foldstart + 1)
                \ . ' Completed tasks '
endfunction

" Restore context {{{1
let &cpo = s:save_cpo
" Modeline {{{1
" vim: ts=8 sw=4 sts=4 et foldenable foldmethod=marker foldcolumn=1
