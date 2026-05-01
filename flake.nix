{
  description = "SaltyPeppermint.github.io — personal website built with Astro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nodejs = pkgs.nodejs_latest;
      in
      {
        packages.default = pkgs.buildNpmPackage {
          pname = "saltypeppermint-website";
          version = "0.0.1";

          src = ./.;

          # After the first `nix build`, replace this with the hash Nix prints.
          # Or compute it ahead of time with `prefetch-npm-deps package-lock.json`.
          npmDepsHash = pkgs.lib.fakeHash;

          nativeBuildInputs = [ nodejs ];

          installPhase = ''
            runHook preInstall
            cp -r dist $out
            runHook postInstall
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = [
            nodejs
            pkgs.nixfmt-rfc-style
            pkgs.npm-check-updates
          ];
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
