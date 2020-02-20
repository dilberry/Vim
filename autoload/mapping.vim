" mapping options {
function! s:TabInsertMode()
	" is completion menu open? cycle to next item
	if pumvisible()
		return "\<c-n>"
	endif

	" if no previous option worked, just use regular tab
	return "\<tab>"
endfunction

function! s:TabInsertModeNeoSnippet()
	" is completion menu open? cycle to next item
	if pumvisible()
		return "\<c-n>"
	endif

	" is there a snippet that can be expanded?
	" is there a placholder inside the snippet that can be jumped to?
	if  neosnippet#expandable_or_jumpable()
		return "\<Plug>(neosnippet_expand_or_jump)"
	endif

	" if no previous option worked, just use regular tab
	return "\<tab>"
endfunction

if dein#tap('neosnippet.vim')
	imap <silent><expr><Tab> <SID>TabInsertModeNeoSnippet()
	smap <silent><expr><Tab> <SID>TabInsertModeNeoSnippet()
else
	imap <silent><expr><Tab> <SID>TabInsertMode()
endif

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

function! s:EnterInsertModeNeoSnippet()
	" is completion menu open? cycle to next item
	if pumvisible()
		if neosnippet#expandable()
			return "\<right>" . "\<Plug>(neosnippet_expand_or_jump)"
		else
			return deoplete#close_popup()
		endif
	endif

	" if no previous option worked, just use regular tab
	return "\<cr>"
endfunction

if dein#tap('deoplete.nvim') && dein#tap('neosnippet.vim')
	imap <silent><expr><cr> <SID>EnterInsertModeNeoSnippet()
endif
