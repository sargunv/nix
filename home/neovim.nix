# Neovim editor (NixVim).
{ ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      sidescrolloff = 8;
      splitbelow = true;
      splitright = true;
      undofile = true;
      updatetime = 250;
      timeoutlen = 300;
      clipboard = "unnamedplus";
      showmode = false;
    };

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    plugins = {
      treesitter = {
        enable = true;
        settings.indent.enable = true;
      };

      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd = {
            enable = true;
            settings.formatting.command = [ "nixfmt" ];
          };
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          ts_ls.enable = true;
          clangd.enable = true;
          taplo.enable = true;
          dockerls.enable = true;
          terraformls.enable = true;
          tailwindcss.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
          bashls.enable = true;
          lua_ls.enable = true;
          cssls.enable = true;
          html.enable = true;
          gopls.enable = true;
          pyright.enable = true;
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 500;
            lsp_format = "fallback";
          };
          formatters_by_ft = {
            javascript = [ "dprint" ];
            typescript = [ "dprint" ];
            javascriptreact = [ "dprint" ];
            typescriptreact = [ "dprint" ];
            json = [ "dprint" ];
            markdown = [ "dprint" ];
            toml = [ "dprint" ];
            css = [ "dprint" ];
            html = [ "dprint" ];
            yaml = [ "dprint" ];
          };
        };
      };

      lint = {
        enable = true;
        lintersByFt = {
          javascript = [ "oxlint" ];
          typescript = [ "oxlint" ];
          javascriptreact = [ "oxlint" ];
          typescriptreact = [ "oxlint" ];
        };
      };

      blink-cmp = {
        enable = true;
        settings = {
          appearance.nerd_font_variant = "normal";
          signature.enabled = true;
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            options.desc = "Find files";
          };
          "<leader>fg" = {
            action = "live_grep";
            options.desc = "Live grep";
          };
          "<leader>fb" = {
            action = "buffers";
            options.desc = "Buffers";
          };
          "<leader>fh" = {
            action = "help_tags";
            options.desc = "Help tags";
          };
          "<leader>fd" = {
            action = "diagnostics";
            options.desc = "Diagnostics";
          };
          "<leader>fr" = {
            action = "lsp_references";
            options.desc = "LSP references";
          };
          "<leader>fs" = {
            action = "lsp_document_symbols";
            options.desc = "Document symbols";
          };
        };
        extensions.fzf-native.enable = true;
      };

      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          filesystem = {
            follow_current_file.enabled = true;
            filtered_items = {
              visible = true;
              hide_dotfiles = false;
              hide_gitignored = false;
            };
          };
        };
      };

      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };

      lualine.enable = true;

      bufferline = {
        enable = true;
        settings.options = {
          diagnostics = "nvim_lsp";
          offsets = [
            {
              filetype = "neo-tree";
              text = "File Explorer";
              highlight = "Directory";
              separator = true;
            }
          ];
        };
      };

      which-key = {
        enable = true;
        settings.spec = [
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
      };

      indent-blankline.enable = true;
      nvim-autopairs.enable = true;
      comment.enable = true;
      web-devicons.enable = true;

      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          open_mapping = "[[<C-\\>]]";
          float_opts.border = "curved";
        };
      };
    };

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
        action = "<cmd>bdelete<cr>";
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
