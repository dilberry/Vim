if !executable('ctags')
	finish
endif

" Tagbar options {
function! ConfigureTagbar()
	if dein#tap('tagbar')
		" Tagbar Toggle
		call LeaderBind('nnoremap', ['b', 't'], 'TagbarToggle', 'Tagbar Toggle', 'tagbar_toggle', v:true)
		let g:tagbar_ctags_bin = $VIMHOME.'\utils\ctags\ctags.exe'
		autocmd VimEnter * nested :call tagbar#autoopen(1)

		if filereadable($VIMHOME.'\utils\ctags\ctags.cfg')
			" TypeScript {
			let g:tagbar_type_typescript = {
				\ 'ctagstype' : 'typescript',
				\ 'deffile' : $VIMHOME.'\utils\ctags\ctags.cfg',
				\ 'kinds'     : [
					\ 'c:classes',
					\ 'c:modules',
					\ 'n:modules',
					\ 'f:functions',
					\ 'v:variables',
					\ 'v:varlambdas',
					\ 'm:members',
					\ 'i:interfaces',
					\ 't:types',
					\ 'e:enums',
					\ 'I:imports',
				\ ]
			\ }
			" }
			" Visual Basic {
			let g:tagbar_type_vb = {
				\ 'ctagstype' : 'vb',
				\ 'deffile' : $VIMHOME.'\utils\ctags\ctags.cfg',
				\ 'kinds'     : [
					\ 's:subroutines',
					\ 'f:functions',
					\ 'v:variables',
					\ 'c:constants',
					\ 'e:enums',
					\ 'n:names',
					\ 'l:labels',
				\ ]
			\ }
			" }
		endif

		call LeaderBindsProcess()
	endif
endfunction
" }

" Gutentags options {
function! ConfigureGutentags()
	if dein#tap('vim-gutentags')
		if filereadable($VIMHOME.'\utils\ctags\ctags.cfg')
			" Include extra defintions for VB6 and TypeScript
			" etags format gives better paths on Windows
			let g:gutentags_ctags_extra_args = ['−−options='.shellescape($VIMHOME.'\utils\ctags\ctags.cfg')]
		endif
		let g:gutentags_cache_dir = $VIMHOME.'\utils\ctags\cache'
		" Let Gutentags separate tags based on Visual Studio and VB6 solutions
		let g:gutentags_project_root = ['.vs', 'node_modules', '*.sln', '*.vbp']
		let g:gutentags_ctags_exclude = ['*.min.js', '*.min.css', '*.assets.json', '*.swagger.json', 'build', 'vendor', '.git', 'node_modules']
	endif
endfunction
" }

" tagbar
call dein#add('https://github.com/majutsushi/tagbar.git')
call dein#config('tagbar', {'hook_post_source': function('ConfigureTagbar') })

" vim-gutentags
call dein#add('https://github.com/ludovicchabant/vim-gutentags.git')
call dein#config('vim-gutentags', {'hook_post_source': function('ConfigureGutentags') })
