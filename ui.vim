" vim-airline options {
function! ConfigureAirline()
	if dein#tap('vim-airline')
		set laststatus=2 " Show 2 lines of status
		set noshowmode   " Don't show mode on statusline, let airline do it instead
		let g:airline_detect_modified           = 1
		let g:airline#extensions#tagbar#enabled = 1
		let g:airline#extensions#ale#enabled    = 1
		let g:airline#extensions#branch#enabled = 1
		let g:airline#extensions#branch#format  = 1

		function! CustomBranchName(name) abort
			let b:airline_branch_ahead = v:false
			try
				let l:git_rev = fugitive#repo().git_chomp('rev-list', '--left-right', '--count', 'origin/'.a:name.'...'.a:name)
				" In the form of Behind Ahead
				let l:git_revs = split(l:git_rev, '\D')
				let l:rev_stats = ''

				" Check behind and ahead
				if l:git_revs[0] != '0' && l:git_revs[1] != '0'
					let l:rev_stats = 'Behind ' . l:git_revs[0] . ' , ' . 'Ahead ' . l:git_revs[1]
					let b:airline_branch_ahead = v:true
				" Check behind
				elseif l:git_revs[0] != '0'
					let l:rev_stats = 'Behind ' . l:git_revs[0]
				" Check ahead
				elseif l:git_revs[1] != '0'
					let l:rev_stats = 'Ahead ' . l:git_revs[1]
					let b:airline_branch_ahead = v:true
				endif

				if l:rev_stats == ''
					return '[' . a:name . ']'
				else
					return '[' . a:name . ': '. l:rev_stats . ']'
				endif
			catch
				return '[' . a:name . ']'
			endtry
		endfunction

		function! BranchColour() abort
			if exists('b:custom_branch') && !empty(b:custom_branch)
				return b:custom_branch
			else
				let l:head = airline#extensions#branch#head()
				let b:custom_branch = CustomBranchName(l:head)
			endif

			if b:airline_branch_ahead
				call airline#parts#define_accent('branch', 'stale')
			else
				call airline#parts#define_accent('branch', 'none')
			endif

			let g:airline_section_b = airline#section#create(['branch'])

			return b:custom_branch
		endfunction

		function! AirlineThemePatch(palette)
			" [ guifg, guibg, ctermfg, ctermbg, opts ].
			" See "help attr-list" for valid values for the "opt" value.
			" http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
			let a:palette.accents.stale = [ '#ff0000', '' , 'red', '', '' ]
		endfunction

		exec 'augroup airline_init-'. bufnr("%")
			autocmd!
			autocmd User AirlineAfterInit call s:airline_init()
			autocmd ShellCmdPost,CmdwinLeave * unlet! b:custom_branch
			autocmd BufLeave <buffer> silent! unlet! b:custom_branch
		augroup END

		function! s:airline_init()
			let b:custom_branch = ''
			let b:airline_branch_ahead = v:false
			call airline#parts#define_empty(['branch'])
			call airline#parts#define_function('branch', 'BranchColour')
			let g:airline_section_b = airline#section#create(['branch'])
			" TODO: Use the following to check when outside a Git repo
			" TODO: call airline#parts#define_condition('foo', 'getcwd() =~ work_dir')

			let g:airline_theme_patch_func = 'AirlineThemePatch'
		endfunction
	endif
endfunction
" }

" vim-airline-themes options {
function! ConfigureAirlineThemes()
	if dein#tap('vim-airline-themes')
		let g:airline_theme = 'wombat'
	endif
endfunction
" }

" indent-guides options {
function! ConfigureIndentGuides()
	if dein#tap('vim-indent-guides')
		let g:indent_guides_enable_on_vim_startup = 1
		let g:indent_guides_default_mapping = 0 " Disable leader mapping

		" indent-guides toggle
		call LeaderBind('nnoremap', ['b', 'g'], 'IndentGuidesToggle', 'Indent Guides Toggle', 'indent_guides_toggle', v:true)

		call LeaderBindsProcess()
	endif
endfunction
" }

" Rainbow options {
function! ConfigurePreRainbow()
	if dein#tap('rainbow')
		let g:rainbow_active = 1 " Enable rainbow by default
	endif
endfunction

function! ConfigurePostRainbow()
	if dein#tap('rainbow')
		let g:rainbow_conf = {
		\	'guifgs': ['deepskyblue3', 'seagreen3', 'darkorchid3', 'firebrick3', 'steelblue3', 'chartreuse3', 'violetred3', 'orangered3'],
		\	'ctermfgs': [ 'brown', 'Darkblue', 'darkgray', 'darkgreen', 'darkcyan', 'darkred', 'darkmagenta', 'brown'],
		\	'operators': '_,_',
		\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
		\	'separately': {
		\		'*': {},
		\		'vim': {
		\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
		\		},
		\		'html': {
		\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
		\		},
		\		'css': 0,
		\	}
		\}

		" rainbow_parentheses toggle
		call LeaderBind('nnoremap', ['b', 'r'], 'RainbowToggle', 'Rainbow Toggle', 'rainbow_toggle', v:true)

		call LeaderBindsProcess()
	endif
endfunction
" }

" vim-airline
call dein#add('https://github.com/vim-airline/vim-airline.git')
call dein#config('vim-airline', {'hook_source': function('ConfigureAirline')})

" vim-airline-themes
call dein#add('https://github.com/vim-airline/vim-airline-themes.git')
call dein#config('vim-airline-themes', {'hook_source': function('ConfigureAirlineThemes'), 'depends': ['vim-airline'], 'on_source': ['vim-airline']})

" vim-colorschemes
call dein#add('https://github.com/flazz/vim-colorschemes.git')

" colour-schemes
call dein#add('https://github.com/daylerees/colour-schemes.git')
call dein#config('colour-schemes', {'rtp': 'vim'})

" random-colorscheme-picker
call dein#add('https://github.com/dilberry/random-colorscheme-picker.git')

" vim-indent-guides
call dein#add('https://github.com/nathanaelkane/vim-indent-guides.git')
call dein#config('vim-indent-guides', {'hook_add': function('ConfigureIndentGuides')})

" rainbow
call dein#add('https://github.com/luochen1990/rainbow.git')
call dein#config('rainbow', {'hook_add': function('ConfigurePreRainbow'), 'hook_post_source': function('ConfigurePostRainbow')})
