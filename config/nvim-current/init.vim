set exrc
set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set completeopt=menuone,noinsert,noselect
set signcolumn=yes

set cmdheight=2

set updatetime=2000

set shortmess+=c

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

call plug#begin('~/.vim/plugged')
"Plug 'neovim/nvim-lspconfig'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'joshdick/onedark.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'junegunn/gv.vim'
Plug 'vuciv/vim-bujo'
Plug 'sbdchd/neoformat'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'justinmk/vim-sneak'
Plug 'itchyny/lightline.vim'
Plug 'justinmk/vim-dirvish'
Plug 'Yggdroot/indentLine'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'martinsione/darkplus.nvim'
Plug 'olimorris/onedarkpro.nvim'
Plug 'honza/vim-snippets'
Plug 'ThePrimeagen/harpoon'
Plug 'ThePrimeagen/vim-be-good'

"Go
Plug 'fatih/vim-go'

call plug#end()

colorscheme onedarkpro
highlight Normal guibg=None

set t_Co=256

let g:indentLine_char = '⦙'

let mapleader = " "
lua require'nvim-treesitter.configs'.setup { highlight = { enable = true } }

nnoremap <leader>u :UndotreeShow<CR>

" Format on save
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_localrmdir='rm -r'
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
nnoremap <leader>pv :Sex!<CR>

" Lightline
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }

let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ ]

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

autocmd CursorHold *.ts :silent call ShowDocumentation()

autocmd BufWritePre *.ts :silent call CocAction('runCommand', 'editor.action.organizeImport')

set noshowmode

" vim TODO
nmap <Leader>tu <Plug>BujoChecknormal
nmap <Leader>th <Plug>BujoAddnormal
let g:bujo#todo_file_path = $HOME . "/.cache/bujo"

" Telescope
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader>pf :lua require('telescope.builtin').find_files()<CR>
nnoremap <Leader>fb :Telescope file_browser<CR>
nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>vh :lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>gc :lua require('telescope.builtin').git_commits()<CR>
nnoremap <leader>gs :lua require('telescope.builtin').git_status()<CR>
nnoremap <leader>gb :lua require('telescope.builtin').git_branches()<CR>


" Harpoon
nnoremap <leader>hm :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>hl :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>hh :lua require("harpoon.ui").nav_next()<CR>
nnoremap <leader>hg :lua require("harpoon.ui").nav_prev()<CR>
nnoremap <leader>ha :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>hs :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>hd :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>hf :lua require("harpoon.ui").nav_file(4)<CR>


" disable vim-go :GoDef short cut (gd)
let g:go_def_mapping_enabled = 0

let g:sneak#s_next = 1

:command RC e $MYVIMRC
:command -nargs=1 CF e %:h/<args>


lua << EOF
local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore installing
  auto_install = true,
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}
EOF


lua << EOF
local onedarkpro = require("onedarkpro")
onedarkpro.setup({
  filetype_hlgroups = {
    yaml = {
      TSField = { fg = "${red}" },
    }
  }
})
EOF

let g:indentLine_setConceal = 0 
let g:vim_json_syntax_conceal= 0

set mouse=
