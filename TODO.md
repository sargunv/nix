# TODO

## Medium priority

- [ ] Enable zramSwap — OOM protection with no perf cost, important with AI Max unified memory.
- [ ] Set `services.displayManager.defaultSession = "plasma"` — auto-login may land on X11 instead of Wayland.
- [ ] Use `programs.eza` module — installed but no `ls`/`ll` aliases without shell integration.
- [ ] Add fzf with zsh integration — fuzzy Ctrl+R history, Ctrl+T file finder, pairs with ripgrep/fd.
- [ ] Add direnv + nix-direnv — auto-loads flake dev shells on `cd`.
- [ ] Remove redundant `i18n.extraLocaleSettings` — every entry matches `defaultLocale`.

## Low priority

- [ ] Add `xdg.enable = true` for proper XDG env vars.
- [ ] Enable Plymouth for smooth boot transition through LUKS prompt.
- [ ] Use `programs.gh` module instead of raw github-cli package.
- [ ] Use home-manager modules for ripgrep/fd (default args like `--smart-case`).
- [ ] Configure zsh history settings (size, dedup, sharing between sessions).
