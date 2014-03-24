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
    draw unitsquare scaled u shifted (7u, 3.5u);
    draw unitsquare xscaled 2u yscaled u shifted (9u, 3.5u);
    %f(x)
    boxplus(5.5u, 5.5u, .5u);

    draw (1u, 4.5u) -- (1u, 3.5u);
    draw (10u, 4.5u) -- (10u, 3.5u);

    %wiring
    drawarrow (3.5u, 4u) -- (3.5u, 5.5u) -- (5.25u, 5.5u);
    drawarrow (5.5u, 4u) -- (5.5u, 5.25u);
    drawarrow (5.75u, 5.5u) -- (7.5u, 5.5u) -- (7.5u, 4.5u);
    drawarrow (7.5u, 4u) -- (7.5u, 2u);

    label(btex $\dots$ etex, (2.5u, 4u));
    label(btex $\dots$ etex, (4.5u, 4u));
    label(btex $\dots$ etex, (6.5u, 4u));
    label(btex $\dots$ etex, (8.5u, 4u));

    pickup pencircle scaled 4pt;
    drawdot (3.5u, 4u);
    drawdot (5.5u, 4u);
    drawdot (7.5u, 4u);

    label(btex $0$ etex, (.5u, 3u));
    label(btex $1$ etex, (1.5u, 3u));
    label(btex $j$ etex, (3.5u, 3u));
    label(btex $i$ etex, (5.5u, 3u));
    label(btex $S_i + S_j$ etex, (8.1u, 3u));
    label(btex $255$ etex, (10.5u, 3u));

    label.bot(btex $K_i$ etex, (7.5u, 2u));
endfig;

end


