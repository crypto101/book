#!/usr/bin/env bash

multiline_sed() {
    local input="$2"
    local expr="$1"
    tr '\n' '\r' < "$input" | sed "$expr" | tr '\r' '\n' > "$input".tmp
    mv "$input".tmp "$input"
}

org2rst() {
    local input="$1"
    local output="$2"
    shift 2

    local prepared="${input}-prepared.org"

    cp "$input" "$prepared"
    sed -i 's/<<<\([^>]*\)>>>/\1/g' "$prepared"

    # [[label-name][Link title]] to :ref:`Link title <label-name>`
    multiline_sed 's/\[\[\([^]]*\)\]\[\([^]]*\)\]\]/:ref:`\2 <\1>`/g' "$prepared"

    pandoc "$prepared" -o "$output"
    sed -i 's/:raw-latex:`\\cite{\([^}]*\)}`/:cite:`\1`/g' "$output"

    for bib_file; do
        printf '\n.. bibliography:: %s\n' "${bib_file}" >> "$output"
    done
}

org2rst Crypto101.org Crypto101.rst Crypto101.bib
