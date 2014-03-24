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
    % symbols and boxes
    oplus(1.5u, 2u, .5u);
    oplus(4.5u, 2u, .5u);
    oplus(7.5u, 2u, .5u);

    draw unitsquare scaled u shifted ( u, 4u);
    draw unitsquare scaled u shifted (4u, 4u);
    draw unitsquare scaled u shifted (7u, 4u);

    pickup pencircle scaled 4pt;

    drawdot (1.5u, 5.5u);
    drawdot (4.5u, 5.5u);
    drawdot (7.5u, 5.5u);

    pickup defaultpen;

    % wiring
    %  key input
    drawarrow (.5u, 4.5u) -- (u, 4.5u);
    drawarrow (3.5u, 4.5u) -- (4u, 4.5u);
    drawarrow (6.5u, 4.5u) -- (7u, 4.5u);
    %  data input
    drawarrow (1.5u, 6u) -- (1.5u, 5u);
    drawarrow (4.5u, 6u) -- (4.5u, 5u);
    drawarrow (7.5u, 6u) -- (7.5u, 5u);
    %  xor output to box
    drawarrow (1.5u, 1.75u) -- (1.5u, 1.25u);
    drawarrow (4.5u, 1.75u) -- (4.5u, 1.25u);
    drawarrow (7.5u, 1.75u) -- (7.5u, 1.25u);
    %  box output
    drawarrow (1.5u, 4u) -- (1.5u, 2.25u);
    drawarrow (4.5u, 4u) -- (4.5u, 2.25u);
    drawarrow (7.5u, 4u) -- (7.5u, 2.25u);
    %  feedback
    drawarrow (0, 2u) -- (1.25u, 2u);
    drawarrow (1.5u, 5.5u) -- (3u, 5.5u) -- (3u, 2u) -- (4.25u, 2u);
    drawarrow (4.5u, 5.5u) -- (6u, 5.5u) -- (6u, 2u) -- (7.25u, 2u);
    draw (7.5u, 5.5u) -- (8u, 5.5u);

    % labels
    label.top(btex $C_1$ etex, (1.5u, 6u));
    label.top(btex $C_2$ etex, (4.5u, 6u));
    label.top(btex $C_3$ etex, (7.5u, 6u));

    label.lft(btex $k$ etex, (.5u, 4.5u));
    label.lft(btex $k$ etex, (3.5u, 4.5u));
    label.lft(btex $k$ etex, (6.5u, 4.5u));

    label(btex $D$ etex, (1.5u, 4.5u));
    label(btex $D$ etex, (4.5u, 4.5u));
    label(btex $D$ etex, (7.5u, 4.5u));

    label.bot(btex $P_1$ etex, (1.5u, 1.25u));
    label.bot(btex $P_2$ etex, (4.5u, 1.25u));
    label.bot(btex $P_3$ etex, (7.5u, 1.25u));

    label.rt(btex $\dots$ etex, (8u, 5.5u));

    label.lft("IV", (0, 2u));
endfig;

end

