{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.plugins.vimtex;
  helpers = import ../helpers.nix { inherit lib; };
in
with lib;
{
  options.plugins.vimtex = {

    enable = mkEnableOption "vimtex";

    package = helpers.mkPackageOption "vimtex" pkgs.vimPlugins.vimtex;

    extraConfig = helpers.mkNullOrOption types.attrs ''
      The configuration options for vimtex without the 'vimtex_' prefix.
      Example: To set 'vimtex_compiler_enabled' to 1, write
        extraConfig = {
          compiler_enabled = true;
        };
    '';
  };

  config =
    let
      globals = {
        enabled = cfg.enable;
      } // cfg.extraConfig;
    in
    mkIf cfg.enable {

      extraPlugins = [ cfg.package ];

      # Usefull for inverse search
      extraPackages = with pkgs; [ pstree xdotool ];

      globals = mapAttrs' (name: value: nameValuePair ("vimtex_" + name) value) globals;
    };
}
