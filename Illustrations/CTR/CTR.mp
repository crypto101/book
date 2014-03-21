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
    % symbols and boxes
    oplus(3u, 0, .5u);

    draw unitsquare scaled u shifted ( u, -.5u);

    drawarrow origin -- (u, 0);
    drawarrow (2u, 0) -- (2.75u, 0);
    drawarrow (3.25u, 0) -- (4.25u, 0);
    drawarrow (1.5u, 1.5u) -- (1.5u, .5u);
    drawarrow (3u, 1.5u) -- (3u, .25u);

    label.lft(btex $N\|00\dots\|i$ etex, origin);
    label(btex $E$ etex, (1.5u, 0));
    label.top(btex $k$ etex, (1.5u, 1.5u));
    label.top(btex $P_i$ etex, (3u, 1.5u));
    label.rt(btex $C_i$ etex, (4.25u, 0));

endfig;

end

