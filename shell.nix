{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/5268ee2ebacbc73875be42d71e60c2b5c1b5a1c7.tar.gz") {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    colormake
    terraform_0_14
    ansible
  ];

  shellHook = ''
    source openrc.sh
    [ -f .venv/bin/activate ] && source .venv/bin/activate
  '';
}
