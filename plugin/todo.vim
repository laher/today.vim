
nnoremap <buffer> <silent> <Plug>TodoPrompt :call todo#prompt()<cr>
nnoremap <buffer> <silent> <Plug>TodoSplit :call todo#split()<cr>


if !hasmapto('<Plug>TodoPrompt', 'n')
   nmap <buffer> <Leader>P <Plug>TodoPrompt
endif
if !hasmapto('<Plug>TodoSplit', 'n')
   nmap <buffer> <Leader>T <Plug>TodoSplit
endif

command -nargs=0 -buffer TodoPrompt call todo#Prompt()<cr>
command -nargs=0 -buffer TodoSplit call todo#Split()<cr>
command -nargs=0 -buffer TodoRefile call todo#Refile()<cr>
