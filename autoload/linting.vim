" ale settings {
function! linting#ConfigureAle()
	if dein#tap('ale')
		call LeaderBind('nnoremap', ['b', 'l'], 'ALEToggle', 'Linting Toggle', 'linting_toggle', v:true)
		nmap <silent> [s <Plug>(ale_previous)
		nmap <silent> ]s <Plug>(ale_next)

		if dein#tap('omnisharp-vim')
			let g:ale_linters = { 'cs': ['Omnisharp'] }
		endif

		call LeaderBindsProcess()
	endif
endfunction
" }

" ale
call dein#add('https://github.com/w0rp/ale.git')
call dein#config('ale', {'hook_source': 'call linting#ConfigureAle()'})
