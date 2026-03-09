# Neovim plugin configuration.
{
  programs.nixvim.plugins = {
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

    which-key.enable = true;

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
}
