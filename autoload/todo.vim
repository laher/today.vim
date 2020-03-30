
function! todo#prompt()
  let curfile = @%
  if curfile != 'inbox.md'
    execute "split" s:getFile()
  endif
  call inputsave()
  let name = input('Enter todo: ')
  call inputrestore()
  " insert a new todo on second line
  call append(1, ' - [ ] ' . name)
  if curfile != 'inbox.md'
    hide
  endif
endfunction

function! s:getFile() abort     
  return get(g:, 'todo_file', '~/inbox.md')
endfunction

function! todo#split()
  if @% != 'inbox.md'
    execute "split" s:getFile()
    resize 5
  endif
  " insert a new todo on second line
  call append(1, ' - [ ] ')
  " go to second line
  execute 2
  " enter insert mode at end of line
  call feedkeys('A')
endfunction

" todo-todos
" Find heading
function! todo#moveToHeading()
  let name = input('Move to heading: ')
  let [lnum, col] = searchpos('^#\+ ' . name, 'n')
  if (lnum > 0)
    execute 'm ' . lnum
  else
    echo ''
    echo 'not found'
  endif
endfunction
" Refile
" Tagging
"
"
function! TodoM()
  let b:lines=[]
  while matchstr('^#\+ ', 'n')
    call add(b:lines, m)
  endwhile
  call fzf#vim#complete(b:lines)
endfunction

