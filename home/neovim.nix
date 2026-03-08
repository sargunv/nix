# Neovim editor (NixVim).
{ pkgs, ... }:
let
  cursortab-src = pkgs.fetchFromGitHub {
    owner = "leonardcser";
    repo = "cursortab.nvim";
    rev = "3762be86c088f7a1d0c394f6ec4f3b460a5787db";
    hash = "sha256-v+8Re49iIzgC9tKzWxh4cAOlvr0rJ1gOBc3imqkYMA0=";
  };

  cursortab-server = pkgs.buildGoModule {
    pname = "cursortab-server";
    version = "unstable-2025-07-04";
    src = "${cursortab-src}/server";
    vendorHash = "sha256-IvJw+89eZ5Ghppjt0KT9IRL8XPyU6XbiAYL3axQO6u4=";
  };

  cursortab-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "cursortab-nvim";
    version = "unstable-2025-07-04";
    src = cursortab-src;
    postInstall = ''
      mkdir -p $out/server
      ln -s ${cursortab-server}/bin/cursortab $out/server/cursortab
    '';
  };
in
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

    colorschemes.gruvbox = {
      enable = true;
      settings.contrast = "hard";
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
          close_command.__raw = ''
            function(bufnum)
              require('mini.bufremove').delete(bufnum, false)
            end
          '';
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
      mini = {
        enable = true;
        mockDevIcons = true;
        modules = {
          bufremove = { };
          pairs = { };
          icons = { };
        };
      };

      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          open_mapping = "[[<C-\\>]]";
          float_opts.border = "curved";
        };
      };
    };

    extraPlugins = [ cursortab-nvim ];

    extraConfigLua = ''
      require("cursortab").setup({
        provider = {
          type = "sweep",
        },
      })
    '';

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
