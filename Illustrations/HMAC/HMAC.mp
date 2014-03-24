prologues := 3;
if scantokens(mpversion) > 1.005:
  outputtemplate :=
else:
  filenametemplate
fi
"%j.mps";

input ../crfuncs;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    %vertical chain
    draw unitsquare scaled u shifted (3u, 7u);
    draw unitsquare scaled u shifted (3u, 5u);
    draw unitsquare scaled u shifted (3u, 3u);
    draw unitsquare scaled u shifted (3u, 1u);

    drawarrow (3.5u, 8.5u) -- (3.5u, 8u);
    drawarrow (3.5u, 7u) -- (3.5u, 6u);
    drawarrow (3.5u, 5u) -- (3.5u, 4u);
    drawarrow (3.5u, 3u) -- (3.5u, 2u);
    drawarrow (3.5u, u) -- (3.5u, .5u);

    %horiz chain(s)
    oplus(2u, 7.5u, .5u);
    oplus(2u, 3.5u, .5u);

    drawarrow (2u, 8u) -- (2u, 7.75u);
    drawarrow (2u, 4u) -- (2u, 3.75u);
    drawarrow (1u, 7.5u) -- (1.75u, 7.5u);
    drawarrow (1u, 3.5u) -- (1.75u, 3.5u);
    drawarrow (2.25u, 7.5u) -- (3u, 7.5u);
    drawarrow (2.25u, 3.5u) -- (3u, 3.5u);

    %labels
    label.lft(btex $P_i$ etex, (u, 7.5u));
    label.lft(btex $P_o$ etex, (u, 3.5u));

    label(btex $(=0$x$3636\dots)$ etex, (u-10pt, 7.5u-15pt));
    label(btex $(=0$x$5c5c\dots)$ etex, (u-10pt, 3.5u-15pt));

    label(btex $\lbrace$ etex rotated 90 xscaled 3.25, (u, 7.5u-30pt));
    label.bot(btex $b$ bits etex, (u, 7.5u-30pt));
    label(btex $\lbrace$ etex rotated 90 xscaled 3.25, (u, 3.5u-30pt));
    label.bot(btex $b$ bits etex, (u, 3.5u-30pt));

    label.top(btex $k$ etex, (2u, 8u));
    label.top(btex $k$ etex, (2u, 4u));

    label.top(btex $m$ etex, (3.5u, 8.5u));
    label.bot(btex $t$ etex, (3.5u, .5u));

    label(btex $\|$ etex, (3.5u, 7.5u));
    label(btex $H$ etex, (3.5u, 5.5u));
    label(btex $\|$ etex, (3.5u, 3.5u));
    label(btex $H$ etex, (3.5u, 1.5u));

endfig;

end

