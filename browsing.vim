" denite options {
function! ConfigureDenite()
	if dein#tap('denite.nvim')
		" Add custom menus
		let s:menus = {}
		call denite#custom#var('menu', 'menus', s:menus)

		function! s:add_denite_item(keys, name, cmd) abort
			if exists('s:menus.' . join(a:keys[:-2], '.'))
				execute 'call add(s:menus.' . join(a:keys[:-2], '.') . '.command_candidates,'. '[' . shellescape(a:name) . ',' . shellescape(a:cmd) . '])'
			else
				execute 'let s:menus.' . join(a:keys[:-1], '.') . ' = '. '{"command_candidates": [' . shellescape(a:name) . ',' . shellescape(a:cmd) . ']}'
			endif
		endfunction

		call LeaderBindsAddCallback(function('s:add_denite_item'))

		" reset 50% winheight on window resize
		augroup deniteresize
			autocmd!
			autocmd VimResized,VimEnter * call denite#custom#option('default',
				\'winheight', winheight(0) / 2)
		augroup end

		" Options
		let s:denite_options = {
		\ 'prompt'                      : 'λ',
		\ 'start_filter'                : v:true,
		\ 'auto_resize'                 : v:true,
		\ 'smartcase'                   : v:true,
		\ 'source_names'                : 'short',
		\ 'highlight_filter_background' : 'CursorLine',
		\ 'highlight_matched_char'      : 'Type',
		\ }

		call denite#custom#option('default', s:denite_options)

		" Sorters
		call denite#custom#source('file',         'sorters', ['sorter/sublime'])
		call denite#custom#source('file/rec/git', 'sorters', ['sorter/sublime'])

		" Matchers
		call denite#custom#source('buffer'      , 'matchers', ['matcher/regexp'])
		call denite#custom#source('file_mru'    , 'matchers', ['matcher/regexp'])
		call denite#custom#source('file'        , 'matchers', ['matcher/fuzzy' ])
		call denite#custom#source('file/rec/git', 'matchers', ['matcher/fuzzy' ])

		" Converters
		call denite#custom#source('file/old', 'converters', ['converter/relative_word'])
		call denite#custom#source('gitstatus', 'converters', ['converter/relative_word'])

		if filereadable($VIMHOME.'\utils\ctags\ctags.cfg')
			" TODO: The outline source can't handle etags format with options files
			call denite#custom#var('outline', 'options', ['−−options='.$VIMHOME.'\utils\ctags\ctags.cfg'])
		endif

		call denite#custom#var('outline', 'file_opt', '-f')

		autocmd FileType denite call s:denite_normal_mappings()
		function! s:denite_normal_mappings() abort
			nnoremap <silent><buffer><expr> <Esc>   denite#do_map('quit')
			nnoremap <silent><buffer><expr> <Tab>   denite#do_map('choose_action')
			nnoremap <silent><buffer><expr> <CR>    denite#do_map('do_action')
			nnoremap <silent><buffer><expr> /       denite#do_map('open_filter_buffer')
			nnoremap <silent><buffer><expr> i       denite#do_map('open_filter_buffer')
			nnoremap <silent><buffer><expr> <Up>    'k'
			nnoremap <silent><buffer><expr> <Down>  'j'
			nnoremap <silent><buffer><expr> yy      denite#do_map('do_action', 'yank')
			nnoremap <silent><buffer><expr> d       denite#do_map('do_action', 'delete')
			nnoremap <silent><buffer><expr> <C-a>   denite#do_map('toggle_select_all')
			nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
			nnoremap <silent><buffer><expr> q       denite#do_map('do_action', 'quickfix')
		endfunction

		autocmd FileType denite-filter call s:denite_filter_mappings()
		function! s:denite_filter_mappings() abort
			imap     <silent><buffer>       <Esc>  <Plug>(denite_filter_quit)
			inoremap <silent><buffer><expr> <Tab>  denite#do_map('choose_action')
			inoremap <silent><buffer>       <Up>   <Esc><C-w>p:call cursor(line('.')-1,0)<CR>
			inoremap <silent><buffer>       <Down> <Esc><C-w>p:call cursor(line('.')+1,0)<CR>
			inoremap <silent><buffer><expr> <C-t>  denite#do_map('do_action', 'tabopen')
			inoremap <silent><buffer><expr> <C-v>  denite#do_map('do_action', 'vsplit')
			inoremap <silent><buffer><expr> <C-x>  denite#do_map('do_action', 'split')
		endfunction

		let s:menus.b = {'description': 'Buffer'}
		let s:menus.b.command_candidates = []
		let s:menus.b.m = {'description': 'Modify'}
		let s:menus.b.m.command_candidates = []
		if dein#tap('denite-ale')
			call LeaderBind('nnoremap <silent>', ['b', 's'], 'Denite ale', 'Syntax Errors', 'syntax_errors', v:true)
		endif

		let s:menus.d = {'description': 'Denite'}
		let s:menus.d.command_candidates = []
		call LeaderBind('nnoremap <silent>', ['d', 'b'], 'Denite buffer'     , 'Buffers', 'buffers', v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'c'], 'Denite colorscheme', 'Colours', 'colours', v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'd'], 'Denite menu'       , 'Menu'   , 'menu'   , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'g'], 'Denite grep'       , 'Grep'   , 'grep'   , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'h'], 'Denite help'       , 'Help'   , 'help'   , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'l'], 'Denite line'       , 'Lines'  , 'lines'  , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'm'], 'Denite mark'       , 'Marks'  , 'marks'  , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'r'], 'Denite -resume'    , 'Resume' , 'resume' , v:true)
		call LeaderBind('nnoremap <silent>', ['d', 'y'], 'Denite neoyank'    , 'Yanks'  , 'yanks'  , v:true)

		let s:menus.f = {'description': 'Files'}
		let s:menus.f.command_candidates = []
		call LeaderBind('nnoremap <silent>', ['f', 'f'], 'Denite file'                  , 'Files'                , 'file'        , v:true)
		call LeaderBind('nnoremap <silent>', ['f', 'm'], 'Denite file/old'              , 'Files (Most Used)'    , 'file/old'    , v:true)
		call LeaderBind('nnoremap <silent>', ['f', 'r'], 'Denite file/rec'              , 'Files (Recursive)'    , 'file/rec'    , v:true)
		call LeaderBind('nnoremap <silent>', ['f', 'g'], 'DeniteProjectDir file/rec/git', 'Files (Git Recursive)', 'file/rec/git', v:true)

		let s:menus.t = {'description': 'Tags'}
		let s:menus.t.command_candidates = []
		call LeaderBind('nnoremap <silent>', ['t', 'b'], 'Denite outline', 'Tags (Buffer)', 'buffer_tag', v:true)
		call LeaderBind('nnoremap <silent>', ['t', 'g'], 'Denite tag'    , 'Tags (Global)', 'global_tag', v:true)

		" Cycle through Denite buffer like the Quickfix buffer using Unimpaired
		nnoremap <silent> [d :<C-u>Denite -resume -immediately -force-quit -cursor-pos=-<C-r>=v:count1<CR><CR>
		nnoremap <silent> ]d :<C-u>Denite -resume -immediately -force-quit -cursor-pos=+<C-r>=v:count1<CR><CR>

		if dein#tap('vim-fugitive')
			let s:menus.g = {'description': 'Git'}
			let s:menus.g.command_candidates = []

			" denite-git options {
			if dein#tap('denite-git')
				" FIXME: This denite menu doesn't work
				let s:menus.g.g = {'description': 'Denite Git'}
				let s:menus.g.g.command_candidates = []
				call LeaderBind('nnoremap <silent>', ['g', 'g', 'b'], 'Denite gitbranch', 'Denite Git Branch', 'denite_gitbranch', v:true)
				call LeaderBind('nnoremap <silent>', ['g', 'g', 's'], 'Denite gitstatus', 'Denite Git Status', 'denite_gitstatus', v:true)
			endif
			" }
		endif

		if executable('rg')
			call denite#custom#var('file/rec', 'command', ['rg', '--files', '--no-heading', '--glob', '!.git', ''])
			call denite#custom#var('grep', 'command', ['rg', '--smart-case'])
			call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
			call denite#custom#var('grep', 'recursive_opts', [])
			call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
			call denite#custom#var('grep', 'separator', ['--'])
			call denite#custom#var('grep', 'final_opts', [])
		endif

		if executable('git')
			call denite#custom#alias('source', 'file/rec/git', 'file/rec')
			call denite#custom#var('file/rec/git', 'command', ['git', 'ls-files', '-co', '--exclude-standard'])
		endif

		call LeaderBindsProcess()
	endif
endfunction
" }

" vim-leader-guide options {
function! ConfigureLeaderGuide()
	if dein#tap('vim-leader-guide')
		let g:lmap = {}
		let g:leaderGuide_vertical = 0
		let g:leaderGuide_position = 'botright'
		let g:leaderGuide_max_size = 30

		call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
		nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
		vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

		if dein#tap('vim-fugitive')
			let g:lmap.g = {'name': 'Git/'}

			" denite-git options {
			if dein#tap('denite.nvim') && dein#tap('denite-git')
				let g:lmap.g.g = {'name': 'Denite Git/'}
			endif
			" }
		endif

		let g:lmap.b = {'name': 'Buffer/'}
		let g:lmap.b.m = {'name': 'Modify/'}
		let g:lmap.f = {'name': 'Files/'}
		let g:lmap.t = {'name': 'Tags/'}

		if dein#tap('denite.nvim')
			let g:lmap.d = {'name': 'Denite/'}
		endif

		function! s:add_leader_guide_item(keys, name, cmd) abort
			let l:local_keys = deepcopy(a:keys)
			let l:key = '[' . join(map(l:local_keys, 'shellescape(v:val)'), '][') . ']'

			execute 'let g:lmap' . l:key . ' = '. '[' . shellescape(a:cmd) . ',' . shellescape(a:name) . ']'
		endfunction

		call LeaderBindsAddCallback(function('s:add_leader_guide_item'))
	endif
endfunction
" }

" vaffle.vim options {
function! ConfigureVaffle()
	if dein#tap('vaffle.vim')
		" Open like vim-vinegar
		nnoremap <silent> - :Vaffle<CR>

		" Disable the mapping in Fugitive
		if dein#tap('vim-fugitive')
			augroup commit_enter
				autocmd!
				autocmd BufEnter COMMIT_EDITMSG nmap <buffer> - <Nop>
			augroup END
		endif

		let g:vaffle_show_hidden_files = 1 " Show hidden files
		function! s:vaffle_options() abort
			" Go up directory like vim-vinegar
			nmap <buffer> -     <Plug>(vaffle-open-parent)
			" Actually quit, unlike vim-vinegar
			nmap <buffer> <Esc> <Plug>(vaffle-quit)
			" Show cursorline in vaffle
			setlocal cursorline
		endfunction

		augroup vimrc_vaffle
			autocmd!
			autocmd FileType vaffle call s:vaffle_options()
		augroup END
	endif
endfunction
" }

if has('python3') && executable('python')
	" denite
	call dein#add('https://github.com/Shougo/denite.nvim.git')
	call dein#config('denite.nvim', {'hook_post_source': function('ConfigureDenite')})

	" denite-ale
	call dein#add('https://github.com/iyuuya/denite-ale.git')
	call dein#config('denite-ale', {'depends': ['ale', 'denite.nvim'], 'on_source': 'denite.nvim'})

	" denite-git
	call dein#add('https://github.com/neoclide/denite-git.git')
	call dein#config('denite-git', {'depends': 'denite.nvim', 'on_source': 'denite.nvim'})

	" denite-extra
	call dein#add('https://github.com/neoclide/denite-extra.git')
	call dein#config('denite-extra', {'depends': 'denite.nvim', 'on_source': 'denite.nvim'})

	" fruzzy
	call dein#add('https://github.com/raghur/fruzzy.git')
	call dein#config('fruzzy', {'depends': 'denite.nvim', 'on_source': 'denite.nvim'})

	" neoyank.vim
	call dein#add('https://github.com/Shougo/neoyank.vim.git')
endif

" vim-leader-guide
call dein#add('https://github.com/hecal3/vim-leader-guide.git')
call dein#config('vim-leader-guide', {'hook_post_source': function('ConfigureLeaderGuide')})

" vaffle.vim
call dein#add('https://github.com/cocopon/vaffle.vim.git')
call dein#config('vaffle.vim', {'hook_post_source': function('ConfigureVaffle')})
