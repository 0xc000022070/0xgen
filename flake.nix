{
  description = "A deadly Go package";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

    version = builtins.substring 0 8 lastModifiedDate;

    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    overlays.default = final: prev: {
      "0xgen" = self.packages.${prev.system}."0xgen";
    };

    overlay = self.overlays.default;

    packages = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      "0xgen" = pkgs.buildGoModule {
        pname = "0xgen";
        src = ./.;
        vendorHash = null;

        inherit version;
      };
    });

    defaultPackage = forAllSystems (system: self.packages.${system}."0xgen");
  };
}
