
function! todo#Prompt()
  call s:ensureDir()
  let curfile = @%
  if curfile != 'inbox.md'
    execute "split" s:getInbox()
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

function! s:getInbox() abort
  return s:getFile('inbox.md')
endfunction

function! s:getFile(name) abort
  return s:getDir() .'/'.a:name
endfunction

function! s:getDir() abort
  let home = fnamemodify('~', ':p')
  echo 'home ' . home
  return get(g:, 'todo_dir', home . '/todo')
endfunction

function! s:ensureDir() abort
  let dir = s:getDir()
  if !isdirectory(dir)
      call mkdir(dir, "p")
  endif
endfunction

function! todo#Split()
  call s:ensureDir()
  if @% != 'inbox.md'
    execute "split" s:getInbox()
    resize 5
  endif
  " insert a new todo on second line
  call append(1, ' - [ ] ')
  " go to second line
  execute 2
  " enter insert mode at end of line
  call feedkeys('A')
endfunction

function! todo#Refile()
  let name = input('Move to file: ')
  execute 'delete t'
  execute 'w'
  execute 'e '.name
  normal! "tp
endfunction

function! todo#FzTodo()
  call fzf#run({'source': 'ls '.s:getDir(), 'sink': function('s:fzfSink'), 'left': '25%'})
endfunction

function! s:fzfSink(arg)
  echom a:arg
  execute 'e '. s:getFile(a:arg)
  " insert a new todo on second line
  call append(1, ' - [ ] ')
  " go to second line
  execute 2
  " enter insert mode at end of line
  call feedkeys('A')
endfunction

" Find heading
function! todo#MoveToHeading()
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

