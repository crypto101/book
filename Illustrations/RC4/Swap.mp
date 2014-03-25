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
    %S
    draw unitsquare xscaled 2u yscaled u shifted (0, 3.5u);
    draw unitsquare scaled u shifted (3u, 3.5u);
    draw unitsquare scaled u shifted (5u, 3.5u);
    draw unitsquare xscaled 2u yscaled u shifted (7u, 3.5u);
    draw (1u, 4.5u) -- (1u, 3.5u);
    draw (8u, 4.5u) -- (8u, 3.5u);

    %wiring
    drawarrow (3.5u, 4u) -- (3.5u, 3u) -- (5.5u, 3u) -- (5.5u, 4u - 6pt);
    drawarrow (5.5u, 4u) -- (5.5u, 5u) -- (3.5u, 5u) -- (3.5u, 4u + 6pt);

    label(btex $\dots$ etex, (2.5u, 4u));
    label(btex $\dots$ etex, (4.5u, 4u));
    label(btex $\dots$ etex, (6.5u, 4u));

    label.llft(btex $i$ etex, (4u, 3.5u));
    label.llft(btex $j$ etex, (6u, 3.5u));
    label.bot(btex $0$ etex, (.5u, 3.5u));
    label.bot(btex $1$ etex, (1.5u, 3.5u));
    label.bot(btex $254$ etex, (7.5u, 3.5u));
    label.bot(btex $255$ etex, (8.5u, 3.5u));

    pickup pencircle scaled 4pt;
    drawdot (3.5u, 4u);
    drawdot (5.5u, 4u);
endfig;

end


