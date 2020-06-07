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
    texlive-standalone \
    texlive-capt-of \
    texlive-cmap \
    texlive-ec \
    texlive-fncychap \
    texlive-tabulary \
    texlive-parskip \
    texlive-needspace \
    texlive-amscls \
    texlive-times \
    texlive-helvetic \
    texlive-anyfontsize \
    texlive-gnu-freefont \
    texlive-dvisvgm \
    texlive-xindy \
    pdf2svg \
    python3-sphinx \
    python3-sphinx-intl \
    python3-sphinxcontrib-bibtex \
    python3-sphinxcontrib-rsvgconverter \
    ghostscript && \
    chmod +x $(readlink -f /usr/bin/mptopdf)

WORKDIR /repo
