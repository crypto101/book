input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    pickup bookpen;
    % symbols and boxes
    oplus(1.5u, 2u, .5u);
    oplus(4.5u, 2u, .5u);

    draw unitsquare scaled u shifted ( u, 4u);
    draw unitsquare scaled u shifted (4u, 4u);

    pickup bookdotpen;

    drawdot (1.5u, 5.5u);

    pickup bookpen;

    % wiring
    %  key input
    drawarrow (.5u, 4.5u) -- (u, 4.5u);
    drawarrow (3.5u, 4.5u) -- (4u, 4.5u);
    %  data input
    drawarrow (1.5u, 6u) -- (1.5u, 5u);
    drawarrow (4.5u, 6u) -- (4.5u, 5u);
    %  xor output to box
    drawarrow (1.5u, 1.75u) -- (1.5u, 1.25u);
    drawarrow (4.5u, 1.75u) -- (4.5u, 1.25u);
    %  box output
    drawarrow (1.5u, 4u) -- (1.5u, 2.25u);
    drawarrow (4.5u, 4u) -- (4.5u, 2.25u);
    %  feedback
    drawarrow (0, 2u) -- (1.25u, 2u);
    drawarrow (1.5u, 5.5u) -- (3u, 5.5u) -- (3u, 2u) -- (4.25u, 2u);

    % labels
    label.top(btex $R=r_1r_2\dots r_b$ etex, (1.5u, 6u));
    label.top(btex $C_i$ etex, (4.5u, 6u));

    label.lft(btex $k$ etex, (.5u, 4.5u));
    label.lft(btex $k$ etex, (3.5u, 4.5u));

    label(btex $D$ etex, (1.5u, 4.5u));
    label(btex $D$ etex, (4.5u, 4.5u));

    label.bot(btex $P_R$ etex, (1.5u, 1.25u));
    label.bot(btex $P_i=p_1p_2\dots p_b$ etex, (4.5u, 1.25u));

    label.lft("IV", (0, 2u));
endfig;

end

