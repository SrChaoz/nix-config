{
  description = "Reproducible Fedora user environment with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkHome = profile: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit profile; };
      };
    in {
      homeConfigurations = {
        # Compatibility alias: the normal profile is the complete one.
        srchaoz = mkHome "full";
        srchaoz-full = mkHome "full";
        srchaoz-minimal = mkHome "minimal";
      };
    };
}
