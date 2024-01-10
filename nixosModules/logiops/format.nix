{ lib, pkgs }:
let
  generators = import ./generator.nix { inherit lib; };
in
{
  libconfig =
    { }:
    {
      type =
        with lib.types;
        let
          valueType =
            nullOr (
              oneOf [
                bool
                int
                float
                str
                path
                (attrsOf valueType)
                (listOf valueType)
              ]
            )
            // {
              description = "Libconfig value";
            };
        in
        valueType;
      generate =
        name: value:
        let
          output = pkgs.writeText name (generators.toLibconfig { } value);
          validator = pkgs.runCommandCC "libconfig-validator" { buildInputs = [ pkgs.libconfig ]; } ''
                      $CC -lconfig -x c - -o "$out" <<EOF
            //    Copyright (C) 2005-2023  Mark A Lindner, ckie
            //    SPDX-License-Identifier: LGPL-2.1-or-later
            #include <stdio.h>
            #include <libconfig.h>
            int main(int argc, char **argv)
            {
              config_t cfg;
              config_init(&cfg);
              if(! config_read_file(&cfg, "${output}"))
              {
                fprintf(stderr, "[libconfig] %s:%d - %s\n", config_error_file(&cfg),
                        config_error_line(&cfg), config_error_text(&cfg));
                config_destroy(&cfg);
                return 1;
              }
              printf("[libconfig] validation ok\n");
            }
            EOF
          '';
        in
        pkgs.runCommandLocal "validated-${name}" { } ''
          ${validator}
          cp ${output} "$out"
        '';
    };
}
