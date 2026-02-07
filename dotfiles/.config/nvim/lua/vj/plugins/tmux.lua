return {
	-- tmuxペイン間をシームレスに移動
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		keys = {
			{ "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate Left" },
			{ "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate Down" },
			{ "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate Up" },
			{ "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate Right" },
		},
	},

	-- tmux内でのLazygit起動
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
