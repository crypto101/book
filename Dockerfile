FROM fedora:29

RUN dnf install -y \
    emacs \
    findutils \
    git \
    graphviz \
    inkscape \
    latexmk \
    make \
    texlive-adjustbox \
    texlive-blindtext \
    texlive-collection-metapost \
    texlive-context \
    texlive-ctablestack \
    texlive-glossaries \
    texlive-memoir \
    texlive-microtype \
    texlive-minted \
    texlive-polyglossia \
    texlive-sourcecodepro \
    texlive-sourceserifpro \
    texlive-wrapfig
    
RUN emacs -Q --batch \
    --eval "(require 'package)" \
    --eval "(add-to-list 'package-archives '(\"org\" . \"https://orgmode.org/elpa/\"))" \
    --eval "(package-initialize t)" \
    --eval "(package-refresh-contents)" \
    --eval "(package-install 'org-plus-contrib)"

WORKDIR /repo
