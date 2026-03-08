# OpenCode CLI configuration with local LLM provider.
{
  programs.opencode = {
    enable = true;
    settings = {
      permission = "allow";
      provider = {
        local = {
          npm = "@ai-sdk/openai-compatible";
          name = "Local LLM";
          options.baseURL = "http://localhost:8000/v1";
          models = {
            "qwen3.5-35b-a3b" = {
              name = "Qwen 3.5 35B-A3B";
            };
          };
        };
      };
      model = "local/qwen3.5-35b-a3b";
    };
  };
}
