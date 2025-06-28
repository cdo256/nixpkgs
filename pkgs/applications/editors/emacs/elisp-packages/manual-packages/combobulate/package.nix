{ pkgs, ... }:

pkgs.emacsPackages.trivialBuild {
  pname = "combobulate";
  version = "0.2.0";
  src = pkgs.fetchFromGitHub {
    owner = "mickeynp";
    repo = "combobulate";
    rev = "17c71802eed2df1a6b25199784806da6763fb90c";
    hash = "sha256-m+06WLfHkdlMkLzP+fah3YN3rHG0H8t/iWEDSrct25E=";
  };
  meta = {
    homepage = "https://github.com/mickeynp/combobulate";
    description = "Structured Navigation and Editing with Combobulate";
    inherit (pkgs.emacs.meta) platforms;
  };
}
