" mpage.vim
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_mpage")
 finish
endif
let g:loaded_mpage= "v1"

" ---------------------------------------------------------------------
"  Public Interface: {{{1
com!							MPageToggle	call mpage#Toggle()

" ---------------------------------------------------------------------
" Public variables {{{1
if !exists("g:mpage_window_prefered_width")
	let g:mpage_window_prefered_width = 80
endif

" =====================================================================
"  Functions: {{{1

" ---------------------------------------------------------------------
" mpage#Toggle: {{{2
fun! mpage#Toggle()
	if !exists("t:mpagetoggled")
		if a:0 > 1
			let nsplits = a:1
		else
			let curwin = winnr()
			let curwinwidth = winwidth(curwin)

			let firstwinline  = line("w0")
			let lastwinline   = line("w$")
			let linesperwin   = lastwinline - firstwinline
			let linecount  = line('$')

			let nsplits = curwinwidth / g:mpage_window_prefered_width

			if (nsplits * linesperwin) > (linecount * 0.9)
				let nsplits = ((linecount * 0.9) / linesperwin) + 1
				let nsplits = floor(nsplits)
			endif
		endif

		call mpage#On(nsplits)

		let t:mpagetoggled=1
	else
		call mpage#Off()
		unlet t:mpagetoggled
	endif
endfun

" ---------------------------------------------------------------------
" mpage#On: {{{2
fun! mpage#On(nsplits)
	let curwin     = winnr()
	let curline    = line('.')
	let curcol     = col('.')
	let firstwinline  = line("w0")
	let lastwinline   = line("w$")
	let linesperwin   = lastwinline - firstwinline
	let linecount  = line('$')

	let firstwinline_off = firstwinline + &scrolloff

	exe "call cursor(".firstwinline.",1)"

	let i = 1
	while i < a:nsplits
		wincmd v
		wincmd l

		let linestart = i * linesperwin + firstwinline_off
		:exe "keepj norm! ".linestart."zt"

		let i = i + 1
	endwhile

	exe curwin."wincmd w"
	:exe "keepj norm! ".(firstwinline + &scrolloff)."zt"
	:exe "call cursor(".curline.",".curcol.")"

	noautocmd windo let w:mpage   = winnr() | setlocal scrollbind

	exe curwin."wincmd w"
endfun

" ---------------------------------------------------------------------
" mpage#Off: {{{2
fun! mpage#Off()
	let t:curwin = winnr()
	noautocmd windo call mpage#_Off()
endfun

" ---------------------------------------------------------------------
" mpage#_Off: {{{2
fun! mpage#_Off()
	if !exists("w:mpage")
		return
	endif

	setlocal noscrollbind

	let curwin = winnr()
	if t:curwin == curwin
		return
	endif

	if t:curwin > curwin
		let t:curwin= t:curwin - 1
	endif
	wincmd c
endfun

