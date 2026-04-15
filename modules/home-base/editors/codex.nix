# OpenAI Codex CLI.
{ pkgs, lib, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.tomlkit ]);

  # Static config keys managed by Nix. Dynamic per-project trust entries
  # added by codex are preserved.
  codexConfig = {
    project_doc_fallback_filenames = [ "CLAUDE.md" ];
    file_opener = "vscode";
    project_root_markers = [
      ".git"
      ".hg"
    ];
    hide_agent_reasoning = false;
    web_search = "live";
    plugins."github@openai-curated" = {
      enabled = true;
    };
    tui.status_line = [
      "model-with-reasoning"
      "context-remaining"
      "current-dir"
      "git-branch"
      "five-hour-limit"
      "weekly-limit"
      "context-window-size"
      "used-tokens"
      "total-input-tokens"
      "total-output-tokens"
    ];
  };

  codexConfigJson = builtins.toJSON codexConfig;

  patchScript = pkgs.writeScript "patch-codex-config" ''
    #!${python}/bin/python3
    import json, sys
    from pathlib import Path
    import tomlkit

    config_path = Path.home() / ".codex" / "config.toml"
    config_path.parent.mkdir(parents=True, exist_ok=True)

    if config_path.exists():
        doc = tomlkit.parse(config_path.read_text())
    else:
        doc = tomlkit.document()

    managed = json.loads(sys.argv[1])

    def deep_merge(target, source):
        for key, value in source.items():
            if isinstance(value, dict) and isinstance(target.get(key), dict):
                deep_merge(target[key], value)
            else:
                target[key] = value

    deep_merge(doc, managed)
    config_path.write_text(tomlkit.dumps(doc))
  '';
in
{
  home.packages = [ pkgs.codex ];
  home.shellAliases.codexd = "codex --dangerously-bypass-approvals-and-sandbox";

  home.activation.codex-config = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${patchScript} ${lib.escapeShellArg codexConfigJson}
  '';
}
