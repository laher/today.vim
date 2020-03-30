
nnoremap <buffer> <silent> <Plug>TodoPrompt :call todo#prompt()<cr>
nnoremap <buffer> <silent> <Plug>TodoSplit :call todo#split()<cr>


if !hasmapto('<Plug>TodoPrompt', 'n')
   nmap <buffer> <Leader>P <Plug>TodoPrompt
   nmap <buffer> <Leader>T <Plug>TodoSplit
endif

command -nargs=0 -buffer TodoPrompt call todo#prompt()<cr>
command -nargs=0 -buffer TodoSplit call todo#split()<cr>
