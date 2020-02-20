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

		imap <C-j>     <Plug>(neosnippet_expand_or_jump)
		smap <C-j>     <Plug>(neosnippet_expand_or_jump)
		xmap <C-j>     <Plug>(neosnippet_expand_target)
	endif
endfunction
" }

" ultisnips options {
function! snippet#ConfigureUltisnips()
	if dein#tap('ultisnips')
		" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
		let g:UltiSnipsExpandTrigger="<tab>"
		let g:UltiSnipsJumpForwardTrigger="<c-j>"
		let g:UltiSnipsJumpBackwardTrigger="<c-k>"

		" If you want :UltiSnipsEdit to split your window.
		let g:UltiSnipsEditSplit="vertical"
	endif
endfunction
" }

" neosnippet.vim
call dein#add('https://github.com/Shougo/neosnippet.vim.git')
call dein#config('neosnippet.vim', {'hook_post_source': 'call snippet#ConfigureNeosnippet()'})

" ultisnips
"call dein#add('https://github.com/SirVer/ultisnips.git')
"call dein#config('ultisnips', {'hook_post_source': 'call snippet#ConfigureNeosnippet()'})

" vim-snippets
call dein#add('https://github.com/honza/vim-snippets.git')
call dein#config('vim-snippets', {'merged': 0})
