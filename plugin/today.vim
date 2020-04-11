
nnoremap <buffer> <silent> <Plug>TodayPrompt :call today#prompt()<cr>
nnoremap <buffer> <silent> <Plug>TodaySplit :call today#split()<cr>


if !hasmapto('<Plug>TodayPrompt', 'n')
   nmap <buffer> <Leader>P <Plug>TodayPrompt
endif
if !hasmapto('<Plug>TodaySplit', 'n')
   nmap <buffer> <Leader>T <Plug>TodaySplit
endif

command -nargs=0 -buffer TodayPrompt call today#Prompt()<cr>
command -nargs=0 -buffer TodaySplit call today#Split()<cr>
command -nargs=0 -buffer TodayRefile call today#Refile()<cr>
command -nargs=0 -buffer TodayRollover call today#Rollover()<cr>
