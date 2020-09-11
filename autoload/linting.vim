" ale settings {
function! linting#ConfigureAle()
	if dein#tap('ale')
		call LeaderBind('nnoremap', ['b', 'l'], 'ALEToggle', 'Linting Toggle', 'linting_toggle', v:true)
		nmap <silent> [s <Plug>(ale_previous)
		nmap <silent> ]s <Plug>(ale_next)

		if dein#tap('omnisharp-vim')
			let g:ale_linters = { 'cs': ['omnisharp'] }
		endif
	endif
endfunction
" }

" ale
call dein#add('https://github.com/dense-analysis/ale.git', { 'rev' : 'v2.6.0' })
call dein#config('ale', {'hook_source': 'call linting#ConfigureAle()', 'depends': 'omnisharp-vim'})
