" Platform detection {
	if !exists('g:is_windows')
		let g:is_windows = has('win16') || has('win32') || has('win64')
	endif
	if !exists('g:is_cygwin')
		let g:is_cygwin = has('win32unix')
	endif
	if !exists('g:is_mac')
		let g:is_mac = !g:is_windows && !g:is_cygwin
							\ && (has('mac') || has('macunix') || has('gui_macvim') ||
							\    (!executable('xdg-open') && system('uname') =~? '^darwin'))
	endif
" }

" GUI options {
	if has('gui_running') " gVim
		function! s:gvim_options() abort
			set guioptions-=t
			" Disable audible bell
			set vb t_vb=
			set guifont=PragmataPro:h10:cANSI:qDRAFT " Select GUI font
			if g:is_windows
				" simalt appears to happen after VimEnter
				" Variables set, during startup, from winheight() will be
				" wrong
				set lines=999
				set columns=9999
				" Fake Alt+Space+x
				simalt ~x
			endif
		endfunction
		autocmd GUIEnter * call s:gvim_options() " Maximise on GUI entry
	elseif has('nvim') && exists('g:GuiLoaded')
		Guifont! PragmataPro:h10:l
		GuiPopupmenu v:false
		GuiTabline v:false
		call GuiWindowMaximized(v:true)
	endif
" }
