if exists("did_load_filetypes_userafter")
  finish
endif
let did_load_filetypes_userafter = 1
augroup filetypedetect
	" VB Classes
	au! BufRead,BufNewFile *.cls setfiletype vb

	" Cake Build scripts
	au! BufRead,BufNewFile *.cake setfiletype cs

	" Csproj
	au! BufRead,BufNewFile *.csproj setfiletype csproj

	" Sln
	au! BufRead,BufNewFile *.sln setfiletype sln

	" XAML
	au! BufRead,BufNewFile *.xaml setfiletype xaml
augroup END
