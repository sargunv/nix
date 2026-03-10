# Neovim keymaps and which-key group definitions.
{
  programs.nixvim = {
    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>f";
        group = "Find";
      }
      {
        __unkeyed-1 = "<leader>g";
        group = "Git";
      }
      {
        __unkeyed-1 = "<leader>l";
        group = "LSP";
      }
      {
        __unkeyed-1 = "<leader>b";
        group = "Buffer";
      }
    ];

    keymaps = [
      {
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle file explorer";
      }
      {
        key = "<S-l>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options.desc = "Next buffer";
      }
      {
        key = "<S-h>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options.desc = "Previous buffer";
      }
      {
        key = "<leader>bd";
        action = "<cmd>lua require('mini.bufremove').delete()<cr>";
        options.desc = "Delete buffer";
      }
      {
        key = "<leader>la";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        options.desc = "Code action";
      }
      {
        key = "<leader>lr";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
        options.desc = "Rename symbol";
      }
      {
        key = "<leader>lf";
        action = "<cmd>lua require('conform').format({ lsp_format = 'fallback' })<cr>";
        options.desc = "Format buffer";
      }
      {
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame_line<cr>";
        options.desc = "Blame line";
      }
      {
        key = "<leader>gp";
        action = "<cmd>Gitsigns preview_hunk<cr>";
        options.desc = "Preview hunk";
      }
      {
        key = "<leader>gr";
        action = "<cmd>Gitsigns reset_hunk<cr>";
        options.desc = "Reset hunk";
      }
      {
        key = "<leader>gs";
        action = "<cmd>Gitsigns stage_hunk<cr>";
        options.desc = "Stage hunk";
      }
      {
        key = "]c";
        action = "<cmd>Gitsigns next_hunk<cr>";
        options.desc = "Next hunk";
      }
      {
        key = "[c";
        action = "<cmd>Gitsigns prev_hunk<cr>";
        options.desc = "Previous hunk";
      }
      {
        key = "<leader>tg";
        action = "<cmd>lua require('toggleterm.terminal').Terminal:new({cmd='lazygit', direction='float'}):toggle()<cr>";
        options.desc = "Lazygit";
      }
      {
        key = "<Esc>";
        mode = "n";
        action = "<cmd>nohlsearch<cr>";
        options.desc = "Clear search highlight";
      }
    ];
  };
}
