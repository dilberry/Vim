" polyglot options {
function! files#ConfigurePrePolyglot()
	if dein#tap('vim-polyglot')
		let g:polyglot_disabled = ['graphql']
	endif
endfunction

function! files#ConfigurePolyglot()
	if dein#tap('vim-polyglot')
		augroup OmniFuncs
			autocmd!
		augroup END

		" html options {
			autocmd OmniFuncs FileType html setlocal omnifunc=htmlcomplete#CompleteTags
		" }

		" css options {
			autocmd OmniFuncs FileType css setlocal omnifunc=csscomplete#CompleteCSS
		" }
	endif
endfunction
" }

" JSBeautify {
function! files#ConfigureJsbeautify()
	if dein#tap('vim-jsbeautify')
		augroup JSBeautify
			autocmd!
		augroup END

		" javascript options {
			autocmd JSBeautify FileType javascript call s:formatter_mappings('call JsBeautify()')
		" }

		" json options {
			autocmd JSBeautify FileType json call s:formatter_mappings('call JsBeautify()')
		" }

		" jsx options {
			autocmd JSBeautify FileType jsx call s:formatter_mappings('call JsxBeautify()')
		" }

		" html options {
			autocmd JSBeautify FileType html call s:formatter_mappings('call HtmlBeautify()')
		" }

		" xml options {
			autocmd JSBeautify FileType xml call s:formatter_mappings('call HtmlBeautify()')
		" }

		" css options {
			autocmd JSBeautify FileType css call s:formatter_mappings('call CSSBeautify()')
		" }
	endif
endfunction
" }

" TODO: This will not be called after dein is cached
" AStyler {
if executable('AStyle')
	augroup AStyler
		autocmd!
	augroup END

	function! g:AstylerCall(astyle_mode) abort
		call system('AStyle --mode=' . a:astyle_mode . ' --style=allman -t -U -S -p -n --delete-empty-lines '.'"'.expand('%').'"')
	endfunction

	" C options {
		autocmd AStyler FileType c call s:formatter_mappings('call g:AstylerCall(' . string('c') . ')')
	" }

	" C++ options {
		autocmd AStyler FileType cpp call s:formatter_mappings('call g:AstylerCall(' . string('c') . ')')
	" }

	" java options {
		autocmd AStyler FileType java call s:formatter_mappings('call g:AstylerCall(' . string('java') . ')')
	" }
endif
" }

" Formatter Menus and Mappings {
	function! s:formatter_menu_check() abort
		if dein#tap('denite.nvim')
			if !exists('g:denite_menu.m')
				let g:denite_menu.m = {'description': 'Modify'}
				let g:denite_menu.m.command_candidates = []
			endif
		endif

		if dein#tap('vim-leader-guide')
			if !exists('g:leader_guide_map.m')
				let g:leader_guide_map.m = {'name': 'Modify/'}
			endif
		endif
	endfunction

	function! s:formatter_mappings(format_cmd) abort
		call s:formatter_menu_check()

		call LeaderBind('nnoremap <buffer>', ['m' , 'a'], a:format_cmd, 'Auto format', 'auto_format', v:true)
	endfunction
" }

" XAML Options {
	augroup XamlOptions
		autocmd!
	augroup END

	function! g:TidyCall() abort
		execute "%!tidy -xml -q --show-errors 0 --show-warnings 0 --indent auto --indent-spaces 4 --indent-attributes 1 " . '"'.expand('%').'"'
	endfunction

	autocmd XamlOptions FileType xaml call s:formatter_mappings('call g:TidyCall()')
" }

" vim-csharp
call dein#add('https://github.com/OrangeT/vim-csharp.git')
call dein#config('vim-csharp', {'on_ft': 'cs'})

" vim-jumpmethod
call dein#add('https://github.com/RobertCWebb/vim-jumpmethod.git')

" vim-polyglot
call dein#add('https://github.com/sheerun/vim-polyglot.git')
call dein#config('vim-polyglot', {'hook_add': 'call files#ConfigurePrePolyglot()', 'hook_post_source': 'call files#ConfigurePolyglot()'})

" vim-jsbeautify
if executable('node')
	call dein#add('https://github.com/maksimr/vim-jsbeautify.git')
	call dein#config('vim-jsbeautify', {'hook_post_source': 'call files#ConfigureJsbeautify()', 'on_ft': ['javascript', 'json', 'jsx', 'html', 'css', 'xml']})
endif
