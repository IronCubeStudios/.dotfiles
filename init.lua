-- BOOTSTRAP lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- BASIC SETTINGS
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- LAZY SETUP
require("lazy").setup({
  spec = {
    -- Catppuccin theme
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
        require("catppuccin").setup({
          flavour = "macchiato", -- latte, frappe, macchiato, mocha
          integrations = {
            treesitter = true,
            native_lsp = {
              enabled = true,
              virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
              },
            },
          },
        })
        vim.cmd.colorscheme("catppuccin")
      end,
    },

    -- Supermaven
    {
      "supermaven-inc/supermaven-nvim",
      config = function()
        require("supermaven-nvim").setup({})
      end,
    },

    -- Comment.nvim
    {
      "numToStr/Comment.nvim",
      opts = {
        -- options here if needed
      },
    },

    -- Telescope + live grep args
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        {
          "nvim-telescope/telescope-live-grep-args.nvim",
          version = "^1.0.0",
        },
      },
      config = function()
        local telescope = require("telescope")
        telescope.setup({})
        telescope.load_extension("live_grep_args")
      end,
    },

    -- NvimTree
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup({})
      end,
    },


  },

  install = {
    colorscheme = { "catppuccin" },
  },
  checker = {
    enabled = true,
  },
})

-- KEYMAPS
vim.keymap.set("n", "<leader>sg", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Live Grep with Args" })
