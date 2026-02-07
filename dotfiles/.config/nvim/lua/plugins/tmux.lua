-- tmux integration for Neovim
return {
  -- Seamless navigation between Neovim and tmux panes
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    keys = {
      { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Navigate Left' },
      { '<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Navigate Down' },
      { '<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Navigate Up' },
      { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Navigate Right' },
      { '<C-\\>', '<cmd>TmuxNavigatePrevious<cr>', desc = 'Navigate Previous' },
    },
  },

  -- LazyGit integration (floating window or tmux)
  {
    'kdheepak/lazygit.nvim',
    cmd = 'LazyGit',
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
}
