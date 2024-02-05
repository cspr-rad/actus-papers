{
  description = "actus-papers";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      latexenv = pkgs.texlive.combine
        {
          inherit (pkgs.texlive) scheme-full latexmk libertine;
        };
      essay = pkgs.runCommand "essay"
        {
          nativeBuildInputs = [ latexenv pkgs.graphviz ];
        }
        ''
          mkdir -p $out
          dot -Tpng ${./essay/standardized-risk-analysis.dot} > standardized-risk-analysis.png
          dot -Tpng ${./essay/non-standardized-risk-analysis.dot} > non-standardized-risk-analysis.png
          cp ${./essay/actus.tex} actus.tex
          latexmk -pdf actus.tex
          cp actus.pdf $out/actus.pdf
        '';
    in
    {
      packages.${system}.default = essay;
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [
          latexenv
          pkgs.graphviz
        ];
      };
    };
}
