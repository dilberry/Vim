" Align options {
function! ConfigureAlign()
	if dein#tap('Align')
		" Prevent mappings
		let g:loaded_AlignMaps = 'v43'
		let g:loaded_AlignMapsPlugin = 'v43'
		let g:loaded_cecutil = 'v17'
	endif
endfunction
" }

" Align
call dein#add('https://github.com/lboulard/Align.git')
call dein#config('Align', {'hook_source': function('ConfigureAlign') })

" vim-sleuth
call dein#add('https://github.com/tpope/vim-sleuth.git')

" vim-surround
call dein#add('https://github.com/tpope/vim-surround.git')

" vim-repeat
call dein#add('https://github.com/tpope/vim-repeat.git')

" vim-unimpaired
call dein#add('https://github.com/tpope/vim-unimpaired.git')

" vim-qfreplace
call dein#add('https://github.com/thinca/vim-qfreplace.git')
