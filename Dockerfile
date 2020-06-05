FROM fedora:32

RUN dnf install -y \
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
    texlive-wrapfig \
    python3-sphinx \
    python3-sphinx-intl \
    python3-sphinxcontrib-bibtex
    
WORKDIR /repo
