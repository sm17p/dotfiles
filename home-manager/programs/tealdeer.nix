_: {
  # Very fast implementation of tldr in Rust
  programs.tealdeer = {
    enable = true;
    settings = {
      display.compact = true;
      updates.auto_update = true;
    };
  };
}
