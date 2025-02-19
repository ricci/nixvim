{ config, lib, ... }:
with lib;
let
  helpers = import ../lib/helpers.nix { inherit lib; };
in
{
  options = {
    options = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "The configuration options, e.g. line numbers";
    };

    globals = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Global variables";
    };
  };

  config = {
    extraConfigLuaPre = optionalString (config.globals != { }) ''
      -- Set up globals {{{
      do
        local nixvim_globals = ${helpers.toLuaObject config.globals}

        for k,v in pairs(nixvim_globals) do
          vim.g[k] = v
        end
      end
      -- }}}
    '' + optionalString (config.options != { }) ''
      -- Set up options {{{
      do
        local nixvim_options = ${helpers.toLuaObject config.options}

        for k,v in pairs(nixvim_options) do
          vim.opt[k] = v
        end
      end
      -- }}}
    '';
  };
}
