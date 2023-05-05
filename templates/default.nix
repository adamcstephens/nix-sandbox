{...}: {
  flake.templates = {
    default = {
      path = ./default;
      description = ''
        Basic template based on flake-parts for a devshell and direnv
      '';
    };
  };
}
