{
  haskellPackages,
  fetchFromGitHub,
  melpaBuild,
}:

let
  inherit (haskellPackages) Agda;
in
melpaBuild rec {
  pname = "agda2-mode";
  version = "2.8.0";
  src = fetchFromGitHub {
    owner = "agda";
    repo = "agda";
    rev = "fe0f6a324480840fdcb855d1e72471be5bd6e39e";
    hash = "sha256-PxbCKqWjJpmVYDz6/f41CiLT4euOGPDLHhzHj2T9ODQ=";
  };

  preBuild = ''
    mv agda2-mode-pkg.el agda2-mode-${version}-pkg.el
  '';

  sourceRoot = "${src.name}/src/data/emacs-mode";

  meta = {
    inherit (Agda.meta) homepage license;
    description = "Agda2-mode for Emacs extracted from Agda package";
    maintainers = [ ];
  };
}
