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
  imports = [
    ./plugins.nix
    ./keymaps.nix
  ];

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

    extraPlugins = [ cursortab-nvim ];

    extraConfigLua = ''
      require("cursortab").setup({
        provider = {
          type = "sweep",
          model = "sweep-next-edit-1.5b",
        },
      })
    '';
  };
}
