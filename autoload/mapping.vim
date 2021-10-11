" mapping options {
function! s:TabInsertMode()
	" is completion menu open? cycle to next item
	if pumvisible()
		return "\<c-n>"
	endif

	if check_back_space()
		return "\<tab>"
	else
		deoplete#mappings#manual_complete()
	endif
endfunction

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

imap <silent><expr><Tab> <SID>TabInsertMode()

" Shift-Tab behaviour in insert mode
" - popup menu previous item OR shift-tab character
function! s:ShiftTabInsertMode()
	" is completion menu open? cycle to previous item
	if pumvisible()
		return "\<c-p>"
	endif

	" if no previous option worked, just use regular shift-tab
	return "\<s-tab>"
endfunction

imap <silent><expr><S-Tab> <SID>ShiftTabInsertMode()

" <CR>: close popup and save indent.
function! s:DeopleteSelect() abort
	return deoplete#close_popup() . "\<CR>"
endfunction

inoremap <silent> <CR> <C-r>=<SID>DeopleteSelect()<CR>
