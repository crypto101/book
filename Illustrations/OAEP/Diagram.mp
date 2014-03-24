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
    %inputs
    draw unitsquare xscaled 3u yscaled u shifted (0, 5.5u);
    draw unitsquare scaled u shifted (4u, 5.5u);
    draw (2u, 5.5u) -- (2u, 6.5u) dashed evenly;

    drawarrow (1.5u, 5.5u) -- (1.5u, 4.25u);
    drawarrow (4.5u, 5.5u) -- (4.5u, 2.25u);

    label(btex $M$ etex, (1u, 6u));
    label(btex $0\dots$ etex, (2.5u, 6u));
    label(btex $R$ etex, (4.5u, 6u));

    label.top(btex $(n-k-p)$ etex, (1u, 6.5u));
    label.top(btex $(p)$ etex, (2.5u, 6.5u));
    label.top(btex $(k)$ etex, (4.5u, 6.5u));

    label.rt(btex $(n-k)$ etex, (1.5u, 5u));

    %G
    draw unitsquare scaled u shifted(2.5u, 3.5u);
    oplus(1.5u, 4u, .5u);

    drawarrow (1.5u, 3.75u) -- (1.5u, .5u);
    drawarrow (4.5u, 4u) -- (3.5u, 4u);
    drawarrow (2.5u, 4u) -- (1.75u, 4u);

    label(btex $G$ etex, (3u, 4u));
    label.bot(btex $(n-k)\leftarrow (k)$ etex, (3u, 3.5u));

    pickup pencircle scaled 4pt;
    drawdot (4.5u, 4u);
    pickup defaultpen;

    %H
    draw unitsquare scaled u shifted(2.5u, 1.5u);
    oplus(4.5u, 2u, .5u);

    drawarrow (4.5u, 1.75u) -- (4.5u, .5u);
    drawarrow (1.5u, 2u) -- (2.5u, 2u);
    drawarrow (3.5u, 2u) -- (4.25u, 2u);

    label(btex $H$ etex, (3u, 2u));
    label.bot(btex $(n-k)\rightarrow (k)$ etex, (3u, 1.5u));

    pickup pencircle scaled 4pt;
    drawdot (1.5u, 2u);
    pickup defaultpen;

    %outputs
    draw unitsquare xscaled 3u yscaled u shifted (0, -.5u);
    draw unitsquare scaled u shifted (4u, -.5u);

    label(btex $X$ etex, (1.5u, 0));
    label(btex $Y$ etex, (4.5u, 0));
    label.bot(btex $(n-k)$ etex, (1.5u, -.5u));
    label.bot(btex $(k)$ etex, (4.5u, -.5u));
endfig;

end

