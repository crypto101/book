prologues := 3;
if scantokens(mpversion) > 1.005:
  outputtemplate :=
else:
  filenametemplate
fi
"%j-%c.mps";

input ../crfuncs;


%%% Drawing scale
numeric u;
u := 1cm;


beginfig(1);
    numeric r;
    numeric d;
    4r = u;
    d = 2r;

    oplus(u, 0, d);
    oplus(3u, 0, d);

    z1 = (u + r, 0);
    z2 = (3u - r, 0);

    drawarrow origin -- (u - r, 0);
    drawarrow z1 -- z2;
    drawarrow z2 shifted (d, 0) -- z2 shifted (d+u, 0);
    drawarrow (u, d + r) -- (u, r);
    drawarrow (3u, d + r) -- (3u, r);

    pickup pencircle scaled .5r;
    drawdot 1/2[z1, z2];
    pickup defaultpen;

    z3 = 1/2[z1, z2] shifted (0, -u);
    drawarrow 1/2[z1, z2] -- z3;

    label.ulft(btex $P_i$ etex, origin);
    label.top(btex $k_i$ etex, (u, d+r));
    label.top(btex $k_i$ etex, (3u, d+r));
    label.top(btex $C_i$ etex, 1/2[z1, z2]);
    label.urt(btex $P_i$ etex, z2 shifted (d+u, 0));
    label.top("Alice", (0, u));
    label.top("Bob", z2 shifted (d+u, u));
    label.bot("Eve", z3);
endfig;

end



