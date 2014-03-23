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
    oplus(1.5u, 4u, .5u);
    oplus(4.5u, 4u, .5u);
    oplus(7.5u, 4u, .5u);

    draw unitsquare scaled u shifted ( u, 2u);
    draw unitsquare scaled u shifted (4u, 2u);
    draw unitsquare scaled u shifted (7u, 2u);

    pickup pencircle scaled 4pt;

    drawdot (1.5u, .5u);
    drawdot (4.5u, .5u);
    drawdot (7.5u, .5u);

    pickup defaultpen;

    % wiring
    %  key input
    drawarrow ( .5u, 2.5u) -- ( u, 2.5u);
    drawarrow (3.5u, 2.5u) -- (4u, 2.5u);
    drawarrow (6.5u, 2.5u) -- (7u, 2.5u);
    %  data input
    drawarrow (1.5u, 4.75u) -- (1.5u, 4.25u);
    drawarrow (4.5u, 4.75u) -- (4.5u, 4.25u);
    drawarrow (7.5u, 4.75u) -- (7.5u, 4.25u);
    %  xor output to box
    drawarrow (1.5u, 3.75u) -- (1.5u, 3u);
    drawarrow (4.5u, 3.75u) -- (4.5u, 3u);
    drawarrow (7.5u, 3.75u) -- (7.5u, 3u);
    %  box ouput
    drawarrow (1.5u, 2u) -- (1.5u, 0);
    drawarrow (4.5u, 2u) -- (4.5u, 0);
    drawarrow (7.5u, 2u) -- (7.5u, 0);
    %  feedback
    drawarrow (0, 4u) -- (1.25u, 4u);
    drawarrow (1.5u, .5u) -- (3u, .5u) -- (3u, 4u) -- (4.25u, 4u);
    drawarrow (4.5u, .5u) -- (6u, .5u) -- (6u, 4u) -- (7.25u, 4u);
    draw (7.5u, .5u) -- (8u, .5u);

    % labels
    label.top(btex $P_1$ etex, (1.5u, 4.75u));
    label.top(btex $P_2$ etex, (4.5u, 4.75u));
    label.top(btex $P_3$ etex, (7.5u, 4.75u));

    label.lft(btex $k$ etex, (.5u, 2.5u));
    label.lft(btex $k$ etex, (3.5u, 2.5u));
    label.lft(btex $k$ etex, (6.5u, 2.5u));

    label(btex $E$ etex, (1.5u, 2.5u));
    label(btex $E$ etex, (4.5u, 2.5u));
    label(btex $E$ etex, (7.5u, 2.5u));

    label.bot(btex $C_1$ etex, (1.5u, 0));
    label.bot(btex $C_2$ etex, (4.5u, 0));
    label.bot(btex $C_3$ etex, (7.5u, 0));

    label.rt(btex $\dots$ etex, (8u, .5u));

    label.lft("IV", (0, 4u));

endfig;

end

