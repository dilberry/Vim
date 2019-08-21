" lightline.vim options {
function! ui#ConfigureLightline()
	if dein#tap('lightline.vim')
		set noshowmode " Don't show mode on statusline, let lightline do it instead
		let s:enable = {}
		let s:enable.tabline = 0
		let s:enable.statusline = 1
		let s:active = {}
		let s:active.left = [
		      \ ['mode'],
		      \ ['fugitive', 'git_ahead'],
		      \ ['filepath', 'readonly'],
		      \ ['filename', 'modified']
		      \ ]
		let s:active.right = [
		      \ ['linter_ok', 'linter_checking', 'linter_errors', 'linter_warnings'],
		      \ ['filetype', 'fileformat', 'fileencoding', 'lineinfo'],
		      \ ['tags']
		      \ ]
		let s:inactive = {}
		let s:inactive.left = [ [ 'filepath','filename' ] ]
		let s:inactive.right = [ [ 'fileinfo', 'lineinfo' ] ]
		let s:component = {}
		let s:separator = { 'left': '', 'right': '' }
                let s:subseparator = {'left': '', 'right': ''}
		let s:component.lineinfo = '%l:%-v'
		let s:component_function = {}
		let s:component_function.mode = 'LightlineMode'
		let s:component_function.fugitive = 'LightlineFugitive'
		let s:component_function.readonly = 'LightlineReadonly'
		let s:component_function.filepath = 'LightlineFilepath'
		let s:component_function.modified = 'LightlineModified'
		let s:component_function.filename = 'LightlineFilename'
		let s:component_function.filetype = 'LightlineFiletype'
		let s:component_function.fileformat = 'LightlineFileformat'
		let s:component_function.fileencoding = 'LightlineFileencoding'
		let s:component_function.tags = 'LightlineTags'
		let s:component_expand = {
		      \     'git_ahead': 'LightlineGitAhead',
		      \     'linter_ok': 'lightline#ale#ok',
		      \     'linter_checking': 'lightline#ale#checking',
		      \     'linter_warnings': 'lightline#ale#warnings',
		      \     'linter_errors': 'lightline#ale#errors',
		      \ }
		let s:component_type = {
		      \     'git_ahead': 'error',
		      \     'linter_ok': 'left',
		      \     'linter_checking': 'left',
		      \     'linter_warnings': 'warning',
		      \     'linter_errors': 'error',
		      \ }
		let g:lightline = {
		      \ 'enable': s:enable,
		      \ 'active': s:active,
		      \ 'inactive': s:inactive,
		      \ 'separator': s:separator,
		      \ 'subseparator': s:subseparator,
		      \ 'component': s:component,
		      \ 'component_function': s:component_function,
		      \ 'component_expand': s:component_expand,
		      \ 'component_type': s:component_type
		      \ }

		let s:ahead_glyph = "\ue009" " 
		let s:ahead_up_glyph = "\ue353" " 
		let s:ahead_down_glyph = "\ue340" " 
		let s:ale_linting_glyph = " \uf250  " " 
		let s:git_glyph = "\ue0a0" " 
		let s:help_glyph = "\uf128" " 
		let s:mo_glyph = "\uf040 " " 
		let s:ro_glyph = "\ue0a2" " 

		function! LightlineMode() abort
			if &filetype ==# 'denite'
				let mode = denite#get_status('raw_mode')
				call lightline#link(tolower(mode[0]))
				return 'Denite'
			endif
			let fname = expand('%:t')
			return &filetype ==# 'tagbar' ? 'Tagbar' : winwidth(0) > 60 ? lightline#mode() : ''
		endfunction

		function! LightlineFugitive() abort
			if &buftype ==# 'terminal' || winwidth(0) < 100
				return ''
			endif
			try
				if &filetype !~? 'denite\|denite-filter\|help\|tagbar' && exists('*fugitive#head')
					let branch = fugitive#head()
					return branch !=# '' ? s:git_glyph.branch : ''
				endif
			catch
			endtry
			return ''
		endfunction

		function! LightlineGitAhead() abort
			try
				if exists('*fugitive#head')
					let l:branch_name = fugitive#head()
					let l:git_rev = fugitive#repo().git_chomp('rev-list', '--left-right', '--count', 'origin/'.l:branch_name.'...'.l:branch_name)
					" In the form of Behind Ahead
					let l:git_revs = split(l:git_rev, '\D')

					" Check ahead and behind; only allow numbers
					if l:git_revs[0] =~# '^\d\+$' && l:git_revs[1] =~# '^\d\+$' && l:git_revs[0] != '0' && l:git_revs[1] != '0'
						return s:ahead_glyph . ' ' . s:ahead_up_glyph . l:git_revs[1] . s:ahead_down_glyph . l:git_revs[0]
					" Check ahead; only allow numbers
					elseif l:git_revs[1] =~# '^\d\+$' && l:git_revs[1] != '0'
						return s:ahead_glyph . ' ' . s:ahead_up_glyph . l:git_revs[1]
					" Check behind; only allow numbers
					elseif l:git_revs[0] =~# '^\d\+$' && l:git_revs[0] != '0'
						return s:ahead_glyph . ' ' . s:ahead_down_glyph . l:git_revs[0]
					endif
				endif
			catch
			endtry

			return ''
		endfunction

		function! LightlineReadonly() abort
			return &buftype ==# 'terminal' ? '' :
			\ &filetype ==# 'vaffle' ? '' :
			\ &filetype ==# 'help' ? s:help_glyph :
			\ &filetype =~# 'fugitive' ? s:git_glyph :
			\ &filetype !~# 'tagbar' && &readonly ? s:ro_glyph :
			\ ''
		endfunction

		function! LightlineFilepath() abort
			if &buftype ==# 'terminal' || &filetype ==# 'tagbar'
				return ''
			endif
			if &filetype ==# 'denite'
				let ctx = get(b:, 'denite_context', {})
				return get(ctx, 'sorters', '')
			endif
			if &filetype =~# 'vaffle\|qf\|help\|denite-filter' || winwidth(0) < 70
				let path_string = ''
			else
				if exists('+shellslash')
					let saved_shellslash = &shellslash
					set shellslash
				endif
				let path_string = substitute(expand('%:p:h'), fnamemodify(expand($HOME),''), '~', '')
				if winwidth(0) < 120 && len(path_string) > 30
					let path_string = substitute(path_string, '\v([^/])[^/]*%(/)@=', '\1', 'g')
				endif
				if exists('+shellslash')
					let &shellslash = saved_shellslash
				endif
			endif

			return path_string
		endfunction

		function! LightlineModified() abort
			return &buftype ==# 'terminal' ? '' :
			\ &filetype =~# 'help\|tagbar' ? '' :
			\ &modified ? s:mo_glyph : &modifiable ? '' :
			\ '-'
		endfunction

		function! LightlineFilename() abort
			return (&buftype ==# 'terminal' ? has('nvim') ? b:term_title . ' (' . b:terminal_job_pid . ')' : '' :
				\ &filetype =~# 'denite\|denite-filter' ? denite#get_status('sources') :
				\ &filetype ==# 'tagbar' ? get(g:lightline, 'fname', '') :
				\ '' !=# expand('%:t') ? expand('%:t') : '[No Name]')
		endfunction

		function! LightlineFiletype() abort
			return &buftype ==# 'terminal' || &filetype =~# 'denite\|denite-filter\|tagbar\|vaffle' ? '' :
			\ winwidth(0) > 120 ? (strlen(&filetype) ? &filetype . (exists('*WebDevIconsGetFileTypeSymbol') ? ' ' . WebDevIconsGetFileTypeSymbol() : '') : 'no ft') : ''
		endfunction

		function! LightlineFileformat() abort
			return &buftype ==# 'terminal' || &filetype =~# 'denite\|denite-filter\|tagbar\|vaffle' ? '' :
			\ winwidth(0) > 120 ? &fileformat . (exists('*WebDevIconsGetFileFormatSymbol') ? ' ' . WebDevIconsGetFileFormatSymbol() : '') : ''
		endfunction

		function! LightlineFileencoding() abort
			return &buftype ==# 'terminal' || &filetype =~# 'denite\|denite-filter\|tagbar\|vaffle' ? '' :
			\ winwidth(0) > 120 ? (strlen(&fileencoding) ? &fileencoding : &encoding) : ''
		endfunction

		function! LightlineTags() abort
			if &filetype !~? 'denite\|tagbar\|vaffle' && exists('*tagbar#currenttag')
				return tagbar#currenttag('%s', '', '')
			endif
			return ''
		endfunction

		let g:lightline.colorscheme = 'nord'
		let s:base0   = ['#808070', 244   ] 
		let s:base00  = ['#666656', 242   ] 
		let s:base01  = ['#4e4e43', 239   ] 
		let s:base02  = ['#303030', 230   ] 
		let s:base03  = ['#151513', 233   ] 
		let s:base1   = ['#949484', 242   ] 
		let s:base2   = ['#a8a897', 248   ] 
		let s:base3   = ['#e8e8d3', 253   ] 
		let s:cyan    = ['#87ceeb', 12    ] 
		let s:green   = ['#7A7A57', 3     ] 
		let s:magenta = ['#8181A6', 13    ] 
		let s:orange  = ['#7A7A57', 3     ] 
		let s:red     = ['#5F8787', 12    ] 
		let s:yellow  = ['#FFEF00', 11    ] 
		let s:none    = ['none'   , 'none'] 

		let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
		let s:p.normal.left     = [[s:base02, s:cyan   ], [s:base3 , s:base00], [s:base3, s:base01], [s:base3, s:base02]]
		let s:p.insert.left     = [[s:base02, s:magenta]] + s:p.normal.left[1:]
		let s:p.replace.left    = [[s:base02, s:red    ]] + s:p.normal.left[1:]
		let s:p.visual.left     = [[s:base02, s:green  ]] + s:p.normal.left[1:]
		let s:p.tabline.left    = [[s:base3 , s:base00 ]                      ]
		let s:p.inactive.left   = [[s:base0 , s:base02 ], [s:base00, s:base02]]
		let s:p.normal.middle   = [[s:none  , s:none   ]                      ]
		let s:p.inactive.middle = copy(s:p.normal.middle)
		let s:p.tabline.middle  = copy(s:p.normal.middle)
		let s:p.normal.error    = [[s:base02, s:yellow ]]
		let s:p.normal.warning  = [[s:yellow, s:base01 ]                      ]
		let s:p.normal.right    = [[s:base02, s:base1  ], [s:base2 , s:base01], [s:base2, s:base02]]
		let s:p.inactive.right  = [[s:base02, s:base00 ], [s:base0 , s:base02]]
		let s:p.tabline.right   = copy(s:p.normal.right)
		let s:p.tabline.tabsel  = [[s:base3 , s:base02 ]                      ]

		let g:lightline#colorscheme#nord#palette = lightline#colorscheme#flatten(s:p)

		" Lightline ALE
		let g:lightline#ale#indicator_checking = "\uf110"
		let g:lightline#ale#indicator_warnings = "\uf071"
		let g:lightline#ale#indicator_errors = "\uf05e"
		let g:lightline#ale#indicator_ok = "\uf00c"
	endif
endfunction
" }

" indent-guides options {
function! ui#ConfigureIndentGuides()
	if dein#tap('vim-indent-guides')
		let g:indent_guides_enable_on_vim_startup = 1
		let g:indent_guides_default_mapping = 0 " Disable leader mapping

		" indent-guides toggle
		call LeaderBind('nnoremap', ['b', 'g'], 'IndentGuidesToggle', 'Indent Guides Toggle', 'indent_guides_toggle', v:true)
	endif
endfunction
" }

" Rainbow options {
function! ui#ConfigurePreRainbow()
	if dein#tap('rainbow')
		let g:rainbow_active = 1 " Enable rainbow by default
	endif
endfunction

function! ui#ConfigurePostRainbow()
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
	endif
endfunction
" }

" lightline.vim
call dein#add('https://github.com/itchyny/lightline.vim.git')
call dein#config('lightline.vim', {'hook_source': 'call ui#ConfigureLightline()', 'on_event': 'VimEnter'})

" lightline-ale
call dein#add('https://github.com/maximbaz/lightline-ale.git')

" vim-devicons
call dein#add('https://github.com/ryanoasis/vim-devicons.git')

" vim-colorschemes
call dein#add('https://github.com/flazz/vim-colorschemes.git')

" colour-schemes
call dein#add('https://github.com/daylerees/colour-schemes.git')
call dein#config('colour-schemes', {'rtp': 'vim'})

" vim-colorscheme-metroid
call dein#add('https://github.com/shinespark/vim-colorscheme-metroid.git')

" random-colorscheme-picker
call dein#add('https://github.com/dilberry/random-colorscheme-picker.git')

" vim-indent-guides
call dein#add('https://github.com/nathanaelkane/vim-indent-guides.git')
call dein#config('vim-indent-guides', {'hook_add': 'call ui#ConfigureIndentGuides()'})

" rainbow
call dein#add('https://github.com/luochen1990/rainbow.git')
call dein#config('rainbow', {'hook_add': 'call ui#ConfigurePreRainbow()', 'hook_post_source': 'call ui#ConfigurePostRainbow()'})
