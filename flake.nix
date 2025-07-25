{
 description = "My first NixOS flake";

 inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  home-manager = {
   url = "github:nix-community/home-manager/release-25.05";
   inputs.nixpkgs.follows = "nixpkgs";
  };
  hyprpanel = {
   url = "github:jas-singhfsu/hyprpanel";
   inputs.nixpkgs.follows = "nixpkgs";
  };
  walker.url = "github:abenz1267/walker"; 
 };

 outputs = { self, nixpkgs, home-manager, ... }@inputs: 
 let 
  system = "x86_64-linux";
 in {
  nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
   inherit system;
   modules = [
    ./configuration.nix

    home-manager.nixosModules.home-manager {
     home-manager.useGlobalPkgs = true;
     home-manager.useUserPackages = true;

     home-manager.users.raistah = import ./home.nix;

     home-manager.extraSpecialArgs = {
      inherit system;
      inherit inputs;
     };
    }
   ];
  };
 };
}
