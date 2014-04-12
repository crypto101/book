input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    pickup bookpen;
    % symbols and boxes
    oplus(4.5u, 2u, .5u);
    oplus(7.5u, 2u, .5u);

    draw unitsquare scaled u shifted (4u, 4u);
    draw unitsquare scaled u shifted (7u, 4u);

    pickup bookdotpen;

    drawdot (4.5u, 5.5u);
    drawdot (7.5u, 5.5u);

    pickup bookpen;

    % wiring
    %  key input
    drawarrow (3.5u, 4.5u) -- (4u, 4.5u);
    drawarrow (6.5u, 4.5u) -- (7u, 4.5u);
    %  data input
    drawarrow (4.5u, 6u) -- (4.5u, 5u);
    drawarrow (7.5u, 6u) -- (7.5u, 5u);
    %  xor output to box
    drawarrow (4.5u, 1.75u) -- (4.5u, 1.25u);
    drawarrow (7.5u, 1.75u) -- (7.5u, 1.25u);
    %  box output
    drawarrow (4.5u, 4u) -- (4.5u, 2.25u);
    drawarrow (7.5u, 4u) -- (7.5u, 2.25u);
    %  feedback
    drawarrow (3.5u, 2u) -- (4.25u, 2u);
    drawarrow (4.5u, 5.5u) -- (6u, 5.5u) -- (6u, 2u) -- (7.25u, 2u);
    draw (7.5u, 5.5u) -- (8u, 5.5u);

    % labels
    label.top(btex $C_{i}\oplus{}X$ etex, (4.5u, 6u));
    label.top(btex $C_{i+1}$ etex, (7.5u, 6u));

    label.lft(btex $k$ etex, (3.5u, 4.5u));
    label.lft(btex $k$ etex, (6.5u, 4.5u));

    label(btex $D$ etex, (4.5u, 4.5u));
    label(btex $D$ etex, (7.5u, 4.5u));

    label.bot(btex $P_{i}'$ etex, (4.5u, 1.25u));
    label.bot(btex $P_{i+1}\oplus{}X$ etex, (7.5u, 1.25u));

    label.lft(btex $\dots$ etex, (3.5u, 2u));
    label.rt(btex $\dots$ etex, (8u, 5.5u));
endfig;

end

