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
    draw unitsquare scaled u shifted (1u, 1.5u);
    draw unitsquare scaled u shifted (5u, 1.5u);

    oplus(1.5u, 0u, .5u);
    oplus(5.5u, 0u, .5u);

    drawarrow (0u, 2u) -- (1u, 2u);
    drawarrow (4u, 2u) -- (5u, 2u);

    drawarrow (1.5u, 1.5u) -- (1.5u, 0.25u);
    drawarrow (5.5u, 1.5u) -- (5.5u, 0.25u);

    drawarrow origin -- (1.25u, 0);
    drawarrow (1.75u, 0) -- (5.25u, 0);
    drawarrow (5.75u, 0) -- (7u, 0);

    label.lft(btex $P_i$ etex, origin);
    label.rt(btex $P_i$ etex, (7u, 0));

    label.lft(btex $k$ etex, (0, 2u));
    label.lft(btex $k$ etex, (4u, 2u));
    label(btex $K_i$ etex, (2u, .75u));
    label(btex $K_i$ etex, (6u, .75u));

    z1 = 1/2[(1.5u, 0), (5.5u, 0)];
    label.top(btex $C_i$ etex, z1 shifted (0, 6pt));

    label(btex $C$ etex, (1.5u, 2u));
    label(btex $C$ etex, (5.5u, 2u));

    pickup pencircle scaled 4pt;

    drawdot z1;
endfig;

end


