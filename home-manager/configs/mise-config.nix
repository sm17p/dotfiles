{...}: {
  home.file.".config/mise/config.toml".text = ''
    [settings]
    idiomatic_version_file_enable_tools = ["java", "node", "ruby", "rust"]
    experimental = true

    [tools]
    bun = "latest"
    deno = "latest"
    elixir = "latest"
    erlang = "latest"
    go = "latest"
    java = "temurin-21"
    node = "lts"
    ruby = "3.4.3"
    rust = "latest"
  '';
}
