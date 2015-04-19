vim-mpage
=========

This VIM plug-in shows a file in multiple synchronized windows, with each
sequential window showing sequential lines of text.

#Installation

```
cd .vim/plugin
git clone https://github.com/lacombar/vim-mpage.git
```

#Usage

```
:MPageToggle
```

will split a window into pages.  Subsequently,

```
:MPageToggle
```

will turn multi-paging off and close all non-active windows.
