" neosnippet options {
function! snippet#ConfigureNeosnippet()
	if dein#tap('neosnippet.vim')
		if dein#tap('vim-snippets')
			let g:neosnippet#disable_runtime_snippets = { '_' : 1 }
			let g:neosnippet#enable_snipmate_compatibility = 1
			let l:snippets_path = dein#get('vim-snippets')['rtp'] . '/snippets'
			let g:neosnippet#snippets_directory = l:snippets_path
		endif

		" Marker concealment
		if has('conceal')
			set conceallevel=2
			set concealcursor=niv
		endif
	endif
endfunction
" }

" neosnippet.vim
call dein#add('https://github.com/Shougo/neosnippet.vim.git')
call dein#config('neosnippet.vim', {'hook_post_source': 'call snippet#ConfigureNeosnippet()'})

" vim-snippets
call dein#add('https://github.com/honza/vim-snippets.git')
call dein#config('vim-snippets', {'merged': 0})
