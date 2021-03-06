
function! s:output_handler(job_id, data, event_type)
    let g:myscratch = bufnr("scratch", 1)
    if a:event_type == "exit"
      echom 'today: job done. Exit code: ' . a:data
      call appendbufline(g:myscratch, '$', 'today: job done. Exit code: ' . a:data)
    else
      for l in a:data
        call appendbufline(g:myscratch, '$', l)
      endfor
    endif
endfunction

function! s:scratch()
    let bnr = bufexists('scratch')
    "echo 'buffer: ' .bnr
    if bnr > 0
      bd scratch
    endif
    split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    "setlocal nobuflisted
    "lcd ~
    file scratch
endfunction

function! today#exec#run_maybe_async(argv)

  if &rtp =~ 'async.vim'
    call s:scratch()
    put ='today: running async job'
    "execute '!date > /tmp/out.log 2>&1'
    let jobid = async#job#start(a:argv, {
        \ 'on_stdout': function('s:output_handler'),
        \ 'on_stderr': function('s:output_handler'),
        \ 'on_exit': function('s:output_handler'),
    \ })
    if jobid > 0
        echom 'today: job started'
    else
        echom 'today: job failed to start'
    endif
  else
    echom 'async.vim not available. Running synchronously: ' . join(a:argv)
    let l:out = system(join(a:argv, ' '))
    echo l:out
  endif
endfunction
