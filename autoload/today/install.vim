

function! today#install#Update()
  call s:install_binary(1)
endfunction

function! today#install#Install()
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
