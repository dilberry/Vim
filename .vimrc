source $VIMRUNTIME/defaults.vim
source $VIMRUNTIME/mswin.vim

set diffexpr=
function! MyDiff()
	let opt = '-a --binary '
	if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	let arg1 = v:fname_in
	if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	let arg2 = v:fname_new
	if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	let arg3 = v:fname_out
	if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	let eq = ''
	if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
			let cmd = '""' . $VIMRUNTIME . '\diff"'
			let eq = '"'
		else
			let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		endif
	else
		let cmd = $VIMRUNTIME . '\diff'
	endif
	silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" Platform detection {
	let s:is_windows = has('win16') || has('win32') || has('win64')
	let s:is_cygwin  = has('win32unix')
	let s:is_mac     = !s:is_windows && !s:is_cygwin
	                 \ && (has('mac') || has('macunix') || has('gui_macvim') ||
	                 \    (!executable('xdg-open') && system('uname') =~? '^darwin'))
" }

" Path correction {
	" This is to make the Vim installation portable
	" Set the VIMHOME path variable to where this vimrc is sourced
	let $VIMHOME = expand('<sfile>:p:h')

	if s:is_windows
		if !executable('xmllint')
			" Add xmllint binary path to PATH
			let $PATH .= ";".$VIMHOME."\\xmllint\\"
		endif

		if !executable('AStyle')
			" Add AStyle binary path to PATH
			let $PATH .= ";".$VIMHOME."\\AStyle\\bin\\"
		endif

		if !executable('ctags')
			" Add ctags binary path to PATH
			let $PATH .= ";".$VIMHOME."\\ctags\\"
		endif

		if !executable('fzf')
			" Add fzf binary path to PATH
			let $PATH .= ";".$VIMHOME."\\fzf\\"
		endif

		if !executable('rg')
			" Add ripgrep binary path to PATH
			let $PATH .= ";".$VIMHOME."\\rg\\"
		endif

		" Add unix utility binaries path to PATH
		let $PATH .= ";".$VIMHOME."\\UnxUtils\\usr\\local\\wbin\\"
	endif

	" Add pylint settings folder
	let $PATH .= ";".$VIMHOME."\\pylint\\"

	set tags+=$VIM."//tags"
" }

" Encoding {
	set encoding=utf-8
" }

" Plug {
	" Deregister a Plugin from vim-plug to prevent loading
	function! s:deregister(repo)
		let repo = substitute(a:repo, '[\/]\+$', '', '')
		let name = fnamemodify(repo, ':t:s?\.git$??')
		call remove(g:plugs, name)
		call remove(g:plugs_order, index(g:plugs_order, name))
	endfunction

	" Check if a Plugin exists
	function! PluginCheck(bundle)
		if matchstr(&rtp, 'plugged'.'\\'.a:bundle) != ''
			return 1
		else
			return 0
		endif
	endfunction

	" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
	call plug#begin('~/vimfiles/plugged')

	" vim-fugitive
	Plug 'https://github.com/tpope/vim-fugitive.git'

	" gundo
	Plug 'https://github.com/sjl/gundo.vim.git'
	
	" vim-airline
	Plug 'https://github.com/vim-airline/vim-airline.git'

	" vim-airline-themes
	Plug 'https://github.com/vim-airline/vim-airline-themes.git'

	" vim-surround
	Plug 'https://github.com/tpope/vim-surround.git'

	" vim-qfreplace
	Plug 'https://github.com/thinca/vim-qfreplace.git'

	" vim-colorschemes
	Plug 'https://github.com/flazz/vim-colorschemes.git'

	" Align
	Plug 'https://github.com/lboulard/Align.git'

	" rainbow_parentheses
	Plug 'https://github.com/kien/rainbow_parentheses.vim.git'

	" omnisharp-vim
	Plug 'https://github.com/OmniSharp/omnisharp-vim.git', { 'for': 'cs' }

	" vim-csharp
	Plug 'https://github.com/OrangeT/vim-csharp.git', { 'for': 'cs' }

	" syntastic
	Plug 'https://github.com/vim-syntastic/syntastic.git'

	" vim-dispatch
	Plug 'https://github.com/tpope/vim-dispatch.git'

	" vim-vinegar
	Plug 'https://github.com/tpope/vim-vinegar.git'

	" YouCompleteMe
	Plug 'https://github.com/Valloric/YouCompleteMe.git'

	" vim-gitgutter
	Plug 'https://github.com/airblade/vim-gitgutter.git'

	" vim-repeat
	Plug 'https://github.com/tpope/vim-repeat.git'

	" tagbar
	Plug 'https://github.com/majutsushi/tagbar.git'

	" vim-gutentags
	Plug 'https://github.com/ludovicchabant/vim-gutentags.git'

	" YAIFA
	Plug 'https://github.com/Raimondi/YAIFA.git'

	" vim-plugin-random-colorscheme-picker
	Plug 'https://github.com/sunuslee/vim-plugin-random-colorscheme-picker.git'

	" vim-indent-guides
	Plug 'https://github.com/nathanaelkane/vim-indent-guides.git'

	" fzf-vim
	Plug 'https://github.com/junegunn/fzf.vim.git'

	" fzf
	Plug 'https://github.com/junegunn/fzf.git'

	" vim-jsbeautify
	Plug 'https://github.com/maksimr/vim-jsbeautify.git'

	" DirDiff
	Plug 'https://github.com/vim-scripts/DirDiff.vim.git'

	" vim-signature
	Plug 'https://github.com/kshenoy/vim-signature.git'

	" Check for unmet dependencies
	if !executable('python')
		call s:deregister('gundo.vim')
	endif

	if !executable('ctags')
		call s:deregister('tagbar')
		call s:deregister('vim-gutentags')
	endif

	if !executable('node')
		call s:deregister('vim-jsbeautify')
	endif

	" Initialise plugin system
	call plug#end()
" }

" Misc options {
	set nowrap         " Set lines to no wrap
	set viminfo+=!     " Set viminfo to store and restore global variables
	set history=700    " Sets how many lines of history VIM has to remember
	set modeline       " Use modelines
	set number         " Display line numbers
	set autochdir      " Auto change working directory to the current file
	set hidden         " Allow changing buffer without saving
	set autoread       " auto-reload files, if there's no conflict
	set shortmess+=IA  " no intro message, no swap-file message
	set updatetime=500 " this setting controls how long to wait (in ms) before fetching type / symbol information.
	set cmdheight=2    " Remove 'Press Enter to continue' message when type information is longer than one line.
" }

" Saving options {
	" Disable swap files and backup files
	set nobk
	set nobackup
	set nowritebackup
	set noswapfile
	set noundofile
" }

" Search options {
	set ignorecase " Ignore case when searching
	set hlsearch   " Highlight search things
	set incsearch  " Make search act like search in modern browsers
" }

" GUI options {
	set nolazyredraw " Don't redraw while executing macros

	if has('gui_running')
		if s:is_windows
			autocmd GUIEnter * simalt ~x " Maximise on GUI entry
			set guifont=Dina:h8:cANSI    " Select GUI font
		endif
		autocmd GUIEnter * set vb t_vb=  " Disable audible bell
	endif
" }

" vim-airline options {
if PluginCheck('vim-airline')
	set laststatus=2
	let g:airline_detect_modified           = 1
	let g:airline_theme                     = 'wombat'
	let g:airline#extensions#tagbar#enabled = 1
endif
" }

" Filetype options {
	filetype on        " Enable filetypes

	filetype plugin on " Enable filetype plugins

	" syntastic settings {
	if PluginCheck('syntastic')
		let g:syntastic_mode_map = { 'mode' : 'passive', 'active_filetypes' : [], 'passive_filetypes' : [] }
		noremap <Leader>c :SyntasticCheck<CR>
	endif

	" Python {
		" syntastic settings {
		if PluginCheck('syntastic')
			let g:syntastic_python_checkers         = ['pylint']
			let g:syntastic_python_pylint_post_args = '--rcfile='.'"'.$VIMHOME.'\pylint\pylint.rc'.'"'
		endif
		" }

		" general options {
			" python syntax {
			if PluginCheck('python-syntax')
				let g:python_highlight_builtin_funcs     = 1
				let g:python_highlight_builtin_objs      = 1
				let g:python_highlight_builtins          = 1
				let g:python_highlight_doctests          = 1
				let g:python_highlight_exceptions        = 1
				let g:python_highlight_string_format     = 1
				let g:python_highlight_string_formatting = 1
				let g:python_highlight_string_templates  = 1
				let g:python_print_as_function           = 1
			endif
			" }

			" python-folding setting
			set nofoldenable
		" }
	" }

	" C# {
		" syntastic settings {
		if PluginCheck('syntastic')
            let g:syntastic_cs_checkers = ['code_checker']
		endif
		" }
	" }
    
	" Visual Basic {
		" Tagbar settings {
			let g:tagbar_type_vb = {
				\ 'ctagstype' : 'vb',
				\ 'deffile' : $VIMHOME."\\ctags\\vb.cfg",
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
	" }
    
	augroup AStyler
		autocmd!
	augroup END

	" C options {
		autocmd AStyler FileType c :nnoremap <Leader>a :call system('AStyle --mode=c --style=allman -t -U -S -p -n --delete-empty-lines '.'"'.expand('%').'"')<CR>
	" }

	" C++ options {
		autocmd AStyler FileType cpp :nnoremap <Leader>a :call system('AStyle --mode=c --style=allman -t -U -S -p -n --delete-empty-lines '.'"'.expand('%').'"')<CR>
	" }

	" java options {
		autocmd AStyler FileType java :nnoremap <Leader>a :call system('AStyle --mode=java --style=allman -t -U -S -p -n --delete-empty-lines '.'"'.expand('%').'"')<CR>
	" }

	" javascript options {
		autocmd AStyler FileType javascript :nnoremap <Leader>a :call system('AStyle --mode=java --style=allman -t -U -S -p -n --delete-empty-lines '.'"'.expand('%').'"')<CR>
	" }

	if !executable('AStyle')
		augroup AStyler
			autocmd!
		augroup END
	endif

	augroup JSBeautify
		autocmd!
	augroup END

	" javascript options {
		autocmd FileType javascript noremap <buffer>  <Leader>a :call JsBeautify()<cr>
	" }

	" json options {
		autocmd FileType json noremap <buffer> <Leader>a :call JsonBeautify()<cr>
	" }

	" jsx options {
		autocmd FileType jsx noremap <buffer> <Leader>a :call JsxBeautify()<cr>
	" }

	" html options {
		autocmd FileType html noremap <buffer> <Leader>a :call HtmlBeautify()<cr>
	" }

	" css options {
		autocmd FileType css noremap <buffer> <Leader>a :call CSSBeautify()<cr>
	" }

	if !executable('node')
		augroup JSBeautify
			autocmd!
		augroup END
	endif

	" markdown options {
	if PluginCheck('vim-markdown')
		let g:vim_markdown_folding_disabled = 1
		if executable('markdown_py')
			augroup markdown
				autocmd BufWritePost * if &ft == 'mkd'
							\| call system('markdown_py '.'"'.expand('%').'"'.' -f '.'"'.expand('%:r').'.html'.'"')
							\| endif
			augroup END
		endif
	endif
	" }

	" XML options {
		let g:xml_syntax_folding = 1
		au FileType xml setlocal foldmethod=syntax
	" }
" }

" Indent options {
	filetype indent on " Enable filetype indentation
	set autoindent     " Auto indent for code blocks
	set smarttab       " Backspace to remove space-indents

	" indent-guides options {
	if PluginCheck('vim-indent-guides')
		let g:indent_guides_enable_on_vim_startup = 1
	endif
	" }
" }

" Key Remapping {
	" Remove the Windows ^M - when the encodings gets messed up
	noremap <Leader>M mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

	" Buffer cycle
	nnoremap <Tab> :bnext<CR>
	nnoremap <S-Tab> :bprevious<CR>

	" Increment/Decrement remapping
	noremap <C-kPlus> <C-A>
	noremap <C-kMinus> <C-X>

	" Swap Normal and Visual mode semicolon and colon
	nnoremap ; :
	nnoremap : ;
	vnoremap ; :
	vnoremap : ;

	" Retain selection after shift operations
	" Taken from http://vimbits.com/bits/20
	vnoremap < <gv
	vnoremap > >gv

	" Yank to EOL, making Y behave more like the other capitals (C and D).
	" Taken from http://vimbits.com/bits/11
	noremap Y y$

	" Gundo Toggle
	if PluginCheck('gundo.vim')
		nnoremap <F5> :GundoToggle<CR>
	endif
" }

" Tags options {
	" Tagbar options {
		if PluginCheck('tagbar')
			" Tagbar Toggle
			nnoremap <silent> <F8> :TagbarToggle<CR>
			let g:tagbar_ctags_bin = $VIMHOME."\\ctags\\ctags.exe"
			autocmd VimEnter * nested :call tagbar#autoopen(1)
		endif
	" }

	" Gutentags options {
		if PluginCheck('vim-gutentags')
			" Include extra defintions for VB6 tags
			let g:gutentags_ctags_extra_args = ["−−options=".shellescape($VIMHOME.'\ctags\ctags.cfg')]
			let g:gutentags_cache_dir = $VIMHOME.'\ctags\cache'
		endif
	" }
" }

" Tab options {
	" Completion options
	set completeopt=longest,menuone

	" Tab completion in commands
	set wildmenu
	set wildmode=list:longest

" Slickfix {
	" Quickfix and qfreplace
	" Turn into leader command with line search of current pattern, open quickfix
	" and qfreplace. On buffer save, save changes back but don't write to file
	function! Slickfix()
		call setqflist([])
		let s:ft_backup = &filetype
		:g//caddexpr expand("%").":".line(".").":". getline(".")
		execute "cw"
		execute "set filetype=".s:ft_backup
	endfunction

	function! QFWinNum()
		redir =>bufliststr
		silent! ls
		redir END
		let buflist = map(filter(split(bufliststr, '\n'), 'v:val =~ "Quickfix List"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
		for bufnum in buflist
			return winbufnr(bufnum)
		endfor
		return -1
	endfunction

	function! SlickWinChange()
		execute ".cc"
		execute "normal zz"
		set nocursorline
		set cursorline
		execute QFWinNum()."wincmd w"
	endfunction

	function! SlickWinClose()
		execute ".cc"
		execute "normal zz"
		set nocursorline
		execute "bdelete ".QFWinNum()
		call setqflist([])
	endfunction

	command! Slickfix call Slickfix()
	noremap <Leader>f * :Slickfix<CR>
	autocmd! BufReadPost quickfix nnoremap <buffer> <Space> :call SlickWinChange()<CR>
" }

" Rainbow Parentheses options {
if PluginCheck('rainbow_parentheses')
	let g:rbpt_colorpairs = [
		\ ['brown',       'RoyalBlue3' ],
		\ ['Darkblue',    'SeaGreen3'  ],
		\ ['darkgray',    'DarkOrchid3'],
		\ ['darkgreen',   'firebrick3' ],
		\ ['darkcyan',    'RoyalBlue3' ],
		\ ['darkred',     'SeaGreen3'  ],
		\ ['darkmagenta', 'DarkOrchid3'],
		\ ['brown',       'firebrick3' ],
		\ ['gray',        'RoyalBlue3' ],
		\ ['black',       'SeaGreen3'  ],
		\ ['darkmagenta', 'DarkOrchid3'],
		\ ['Darkblue',    'firebrick3' ],
		\ ['darkgreen',   'RoyalBlue3' ],
		\ ['darkcyan',    'SeaGreen3'  ],
		\ ['darkred',     'DarkOrchid3'],
		\ ['red',         'firebrick3' ],
		\ ]

	function! Config_Rainbow()
		call rainbow_parentheses#load(0)                       " Load Round brackets
		call rainbow_parentheses#load(1)                       " Load Square brackets
		call rainbow_parentheses#load(2)                       " Load Braces
		autocmd TastetheRainbow VimEnter * call Load_Rainbow() " 64bit Hack - Set VimEnter after syntax load
	endfunction

	function! Load_Rainbow()
		call rainbow_parentheses#activate()
	endfunction

	augroup TastetheRainbow
		autocmd!
		autocmd Syntax * call Config_Rainbow()                    " Load rainbow_parentheses on syntax load
		autocmd ColorScheme * call rainbow_parentheses#activate() " Reactivate on Colour Scheme change
	augroup END

	" rainbow_parentheses toggle
	nnoremap <silent> <Leader>t :call rainbow_parentheses#toggle()<CR>
endif
" }

" fzf options {
if PluginCheck('fzf.vim')
	" Default fzf layout
	" - down / up / left / right
	let g:fzf_layout = { 'down': '~40%' }

	" CTRL-A CTRL-Q to select all and build quickfix list
	function! s:build_quickfix_list(lines)
		call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
		copen
		cc
	endfunction

	function! s:align_lists(lists)
		let maxes = {}
		for list in a:lists
			let i = 0
			while i < len(list)
				let maxes[i] = max([get(maxes, i, 0), len(list[i])])
				let i += 1
			endwhile
		endfor

		for list in a:lists
			call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
		endfor

		return a:lists
	endfunction

	function! s:btags_source(tag_cmds)
		if !filereadable(expand('%'))
			throw 'Save the file first'
		endif

		for cmd in a:tag_cmds
			let lines = split(system(cmd), "\n")
			if !v:shell_error && len(lines)
				break
			endif
		endfor

		if v:shell_error
			throw get(lines, 0, 'Failed to extract tags')
		elseif empty(lines)
			throw 'No tags found'
		endif

		return map(s:align_lists(map(lines, 'split(v:val, "\t")')), 'join(v:val, "\t")')
	endfunction

	function! s:btags_sink(lines)
		if len(a:lines) < 2
			return
		endif

		normal! m'
		let cmd = s:action_for(a:lines[0])
		if !empty(cmd)
			execute 'silent' cmd '%'
		endif

		let qfl = []
		for line in a:lines[1:]
			execute split(line, "\t")[2]
			call add(qfl, {'filename': expand('%'), 'lnum': line('.'), 'text': getline('.')})
		endfor

		if len(qfl) > 1
			call setqflist(qfl)
			copen
			wincmd p
			cfirst
		endif

		normal! zz
	endfunction

	function! s:btags(query, ...)
		let args = copy(a:000)
		let escaped = fzf#shellescape(expand('%'))
		let null = s:is_windows ? 'nul' : '/dev/null'
		let sort = has('unix') && !has('win32unix') && executable('sort') ? '| sort -s -k 5' : ''
		let tag_cmds = (len(args) > 1 && type(args[0]) != type({})) ? remove(args, 0) : [
		\ printf('ctags -f - --sort=yes --excmd=number --language-force=%s --options=%s %s 2> %s %s', &filetype, shellescape($VIMHOME.'\ctags\ctags.cfg'), escaped, null, sort),
		\ printf('ctags -f - --sort=yes --excmd=number --options=%s %s 2> %s %s', shellescape($VIMHOME.'\ctags\ctags.cfg'), escaped, null, sort)]

		if type(tag_cmds) != type([])
			let tag_cmds = [tag_cmds]
		endif

		try
			call fzf#run({
			\ 'source':  s:btags_source(tag_cmds),
			\ 'options': '--reverse -m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index --prompt "BTags> "',
			\ 'down'   : '40%',
			\ 'sink'   : function('s:btags_sink')})
		catch
			echohl WarningMsg
			echom v:exception
			echohl None
		endtry
	endfunction

	command! -bang -nargs=* BTags call s:btags(<q-args>, <bang>0)

	" Pretend to be CtrlP
	noremap <c-p> :BTags<CR>

	let g:fzf_action = {
		\ 'ctrl-q': function('s:build_quickfix_list'),
		\ 'ctrl-t': 'tab split',
		\ 'ctrl-x': 'split',
		\ 'ctrl-v': 'vsplit' 
	\}

	let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

	if executable("rg")
		" Find files using Ripgrep and FZF
		command! -bang -nargs=* Find
		\ call fzf#vim#grep(
		\   'rg --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
		\   <bang>0 ? fzf#vim#with_preview('up:60%')
		\           : fzf#vim#with_preview('right:50%:hidden', '?'),
		\   <bang>0)

		command! -bang -nargs=* GFind
		\ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>).' -- :/', 0, <bang>0)
		

	endif
endif
" }

" vim vinegar options {
if PluginCheck('vim-vinegar')
	autocmd FileType netrw setl bufhidden=wipe
endif
" }

" Omnisharp options {
	augroup omnisharp_commands
	    autocmd!

	    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
	    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

	    " Synchronous build (blocks Vim)
	    "autocmd FileType cs nnoremap <F5> :wa!<cr>:OmniSharpBuild<cr>
	    " Builds can also run asynchronously with vim-dispatch installed
	    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
	    " automatic syntax check on events (TextChanged requires Vim 7.4)
	    " autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
	    autocmd BufEnter,BufWritePost *.cs SyntasticCheck

	    " Automatically add new cs files to the nearest project on save
	    autocmd BufWritePost *.cs call OmniSharp#AddToProject()

	    "show type information automatically when the cursor stops moving
	    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

	    "The following commands are contextual, based on the current cursor position.

	    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
	    autocmd FileType cs nnoremap <leader>fi :OmniSharpFindImplementations<cr>
	    autocmd FileType cs nnoremap <leader>ft :OmniSharpFindType<cr>
	    autocmd FileType cs nnoremap <leader>fs :OmniSharpFindSymbol<cr>
	    autocmd FileType cs nnoremap <leader>fu :OmniSharpFindUsages<cr>
	    "finds members in the current buffer
	    autocmd FileType cs nnoremap <leader>fm :OmniSharpFindMembers<cr>
	    " cursor can be anywhere on the line containing an issue
	    autocmd FileType cs nnoremap <leader>x  :OmniSharpFixIssue<cr>
	    autocmd FileType cs nnoremap <leader>fx :OmniSharpFixUsings<cr>
	    autocmd FileType cs nnoremap <leader>tt :OmniSharpTypeLookup<cr>
	    autocmd FileType cs nnoremap <leader>dc :OmniSharpDocumentation<cr>
	    "navigate up by method/property/field
	    autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
	    "navigate down by method/property/field
		autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>

	augroup END

    let g:OmniSharp_server_type = 'roslyn'  
    let g:OmniSharp_prefer_global_sln = 1  
    let g:OmniSharp_timeout = 10
	let g:OmniSharp_selector_ui = 'fzf'

	" Contextual code actions (requires CtrlP or unite.vim)
	nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
	" Run code actions with text selected in visual mode to extract method
	vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

	" rename with dialog
	nnoremap <leader>nm :OmniSharpRename<cr>
	nnoremap <F2> :OmniSharpRename<cr>
	" rename without dialog - with cursor on the symbol to rename... ':Rename newname'
	command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

	" Force OmniSharp to reload the solution. Useful when switching branches etc.
	nnoremap <leader>rl :OmniSharpReloadSolution<cr>
	nnoremap <leader>cf :OmniSharpCodeFormat<cr>
	" Load the current .cs file to the nearest project
	nnoremap <leader>tp :OmniSharpAddToProject<cr>

	" Start the omnisharp server for the current solution
	nnoremap <leader>ss :OmniSharpStartServer<cr>
	nnoremap <leader>sp :OmniSharpStopServer<cr>

	" Add syntax highlighting for types and interfaces
	nnoremap <leader>th :OmniSharpHighlightTypes<cr>
" }

" vim: set fdm=indent : normal zi
