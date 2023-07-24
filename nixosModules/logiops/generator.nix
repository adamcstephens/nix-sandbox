{lib}: let
  libStr = lib.strings;
in {
  /*
   Generates a libconfig configuration file.
  *
  * Currently quite close to fully-featured, though there are probably some
  * oversights not covered by the test (./tests/misc.nix) and automated validator. (//pkgs/pkgs-lib)
  *
  * https://hyperrealm.github.io/libconfig/libconfig_manual.html
  */
  toLibconfig = {}: v: let
    isFloat = builtins.isFloat or (x: false);
    isHexString = str: builtins.match "^[+-]?0x[0-9a-fA-F]+$" str != null;
    isOctalString = str: builtins.match "^[+-]?0[1-7][0-7]*$" str != null;
    isLongString = str: builtins.match "^[+-]?[0-9]+L$" str != null;
    isNumber = x: (isHexString x) || (isOctalString x) || (isLongString x);

    # > An array may have zero or more elements, but the elements must
    # > all be *scalar* values of the same type.
    isArray = x: let
      typed = builtins.groupBy type x;
      filtered = builtins.removeAttrs typed ["null" "aggregate"];
    in
      # > ... *scalar* values..
      !(typed ? aggregate)
      &&
      # > ..of the same type
      lib.length (builtins.attrNames filtered) <= 1;

    type = x:
      with builtins;
        if x == null
        then "null"
        # > A scalar type (integer, 64-bit integer, floating point, boolean, or string)
        else if isBool x
        then "bool"
        else if isInt x
        then "int"
        else if isFloat x
        then "float"
        else if isString x
        then
          if isHexString x
          then "hex"
          else if isOctalString x
          then "octal"
          else if isLongString x
          then "long"
          else "string"
        else
          # > An aggregate type (a group, array, or list),
          "aggregate";

    expr = ind: x:
      with builtins;
        if x == null
        then ""
        else if isBool x
        then bool ind x
        else if isInt x
        then num ind x
        else if isFloat x
        then num ind x
        else if isString x
        then
          if isNumber x
          then lit ind x
          else str ind x
        else if isPath x
        then path ind x
        else if isList x
        then list ind x
        else if isAttrs x
        then attrs ind x
        else abort "generators.toLibconfig: should never happen (v = ${v})";

    literal = ind: x: ind + x;

    bool = ind: x:
      literal ind (
        if x
        then "true"
        else "false"
      );
    num = ind: x: literal ind (toString x);
    str = ind: x: literal ind ''"${x}"'';
    key = ind: x: literal ind "${x}: ";
    path = ind: x: literal ind (toString x);
    lit = ind: x: literal ind "${x}";

    indent = ind: expr "\t${ind}";

    item = ind:
      libStr.concatMapStringsSep ''
        ,
      '' (indent ind);

    list = ind: x:
      if isArray x
      then
        libStr.concatStringsSep "\n" [
          (literal ind "[")
          (item ind x)
          (literal ind "]")
          ""
        ]
      else
        libStr.concatStringsSep "\n" [
          (literal ind "(")
          (item ind x)
          (literal ind ")")
          ""
        ];

    attrs = ind: x:
      libStr.concatStringsSep "\n" [
        (literal ind "{")
        (attr false ind x)
        (literal ind "}")
        ""
      ];

    attr = top: ind: x: let
      attrFilter = name: value: name != "_module" && value != null;
      newInd =
        if top
        then ind
        else "\t${ind}";
    in
      libStr.concatStringsSep "\n" (lib.flatten (lib.mapAttrsToList
        (name: value:
          lib.optional (attrFilter name value) [
            (key newInd name)
            (expr newInd value)
          ])
        x));
  in (
    if v != null && builtins.isAttrs v
    then attr true "" v
    else
      abort
      "generators.toLibconfig: top-level value must be an attrset (was ${v})"
  );
}
