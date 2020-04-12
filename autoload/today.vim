
function! today#Prompt()
  call s:ensureDir()
  let curfile = @%
  if curfile != 'today.md'
    execute "split" s:getInbox()
  endif
  call inputsave()
  let name = input('Enter todo: ')
  call inputrestore()
  " insert a new todo on second line
  call append(1, ' - [ ] ' . name)
  if curfile != 'today.md'
    hide
  endif
endfunction

function! s:getInbox() abort
  return s:getFile('today.md')
endfunction

function! s:getFile(name) abort
  return s:getDir() .'/'.a:name
endfunction

function! s:getDir() abort
  let home = fnamemodify('~', ':p')
  echo 'home ' . home
  return get(g:, 'today_dir', home . '/today')
endfunction

function! s:ensureDir() abort
  let dir = s:getDir()
  if !isdirectory(dir)
      call mkdir(dir, "p")
  endif
endfunction

function! today#Split()
  call s:ensureDir()
  if @% != 'today.md'
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

function! today#Rollover()
  let l:cmd = printf('today rollover')
  let l:out = system(l:cmd)
  if v:shell_error != 0
    call s:handle_errors(l:out)
  endif

  execute ":e"
endfunction

function! today#Refile()
  "let name = input('Move to file: ')
  execute 'delete t'
  execute 'w'
  call fzf#run({'source': 'ls '.s:getDir(), 'sink': function('s:fzfSinkRefile'), 'left': '25%'})
endfunction

function! today#FzTodo()
  call fzf#run({'source': 'ls '.s:getDir(), 'sink': function('s:fzfSink'), 'left': '25%'})
endfunction

function! s:fzfSinkRefile(arg)
  execute 'e '. s:getFile(a:arg)
  execute 2
  normal! "tp
  call feedkeys('A')
endfunction

function! s:fzfSink(arg)
  execute 'e '. s:getFile(a:arg)
  " insert a new todo on second line
  call append(1, ' - [ ] ')
  " go to second line
  execute 2
  " enter insert mode at end of line
  call feedkeys('A')
endfunction

" Find heading
function! today#MoveToHeading()
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

function! today#Update()
  call s:install_binary(1)
endfunction

function! today#Install()
  call s:install_binary(0)
endfunction

function! s:install_binary(update)
  let today_addr = 'github.com/laher/today'
  let argv = ['go', 'get']
  if a:update
    call add(argv, '-u')
  endif
  let argv += [ '-v', today_addr]
  call today#exec#run_maybe_async(argv)
endfunction
