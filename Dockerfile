FROM fedora:29

RUN dnf install -y texlive-glossaries texlive-minted texlive-wrapfig \
          texlive-collection-metapost texlive-memoir texlive-adjustbox \
          texlive-blindtext texlive-context latexmk texlive-sourceserifpro \
          texlive-sourcecodepro texlive-microtype texlive-polyglossia texlive-ctablestack \
          emacs graphviz inkscape make git findutils
    
RUN emacs -Q --batch \
          --eval "(require 'package)" \
          --eval "(add-to-list 'package-archives '(\"org\" . \"https://orgmode.org/elpa/\"))" \
          --eval "(package-initialize t)" \
          --eval "(package-refresh-contents)" \
          --eval "(package-install 'org-plus-contrib)"

WORKDIR /repo