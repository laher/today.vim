
function! today#tagging#DoneNow() abort
  call today#tagging#Tag('done', strftime("%Y-%m-%d"))
endfunction

function! today#tagging#Tag(tag, value) abort
  let tagVal = a:tag
  if a:value
    let tagVal .= a:value
  endif
  execute printf('normal! A [%s](tag://%s:%s)', a:tag, tagVal)
endfunction

function! today#tagging#Prompt() abort
  let tagVal = input('Enter tag[:value] ')
  let tagParts = split(tagVal, ':')
  execute printf('normal! A [%s](tag://%s)', tagParts[0], tagVal)
endfunction
