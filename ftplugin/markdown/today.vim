""" TODO: move these definitions into ftplugin/md/today.vim ?
command! -nargs=0 TodayRefile call today#Refile()
command! -nargs=0 TodayToggle call today#Toggle()
command! -nargs=0 TodayDone call today#Done()

nmap <LocalLeader>r :call today#Rollover()<CR>
nmap <LocalLeader>f :call today#Refile()<CR>
nmap <LocalLeader>x :call today#Done()<CR>
nmap <LocalLeader>a :call today#Add('')<CR>
nmap <LocalLeader>s :call today#Toggle()<CR>
nmap <LocalLeader>c :call today#ChooseStatus()<CR>
nmap <LocalLeader>m :call today#Move()<CR>
nmap <LocalLeader>j :m .+1<CR>==
nmap <LocalLeader>k :m .-2<CR>
""" date heading
nmap <LocalLeader>d i## <C-R>=strftime('%Y-%m-%d')<CR><CR><CR> - [ ]  
nmap <LocalLeader>t :call today#tagging#Prompt()<CR>
nmap <LocalLeader>d :call today#tagging#DoneNow()<CR>

inoremap <expr> <c-x><c-k> fzf#vim#complete(fzf#wrap({
  \ 'prefix': '',
  \ 'source': 'today statuses',
  \ 'reducer': { lines -> split(lines[0])[0] }}))

