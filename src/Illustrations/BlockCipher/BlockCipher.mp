input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    pickup bookpen;
    draw unitsquare scaled u shifted (u, -.5u);
    draw unitsquare scaled u shifted (3u, -.5u);

    drawarrow origin -- (u, 0);
    drawarrow (2u, 0) -- (3u, 0);
    drawarrow (4u, 0) -- (5u, 0);

    drawarrow (1.5u, 1u) -- (1.5u, .5u);
    drawarrow (3.5u, 1u) -- (3.5u, .5u);

    label(btex $E$ etex, (1.5u, 0));
    label(btex $D$ etex, (3.5u, 0));

    label.ulft(btex $P$ etex, origin);
    label.urt(btex $P$ etex, (5u, 0));
    label.top(btex $C$ etex, (2.5u, 0));

    label.top(btex $k$ etex, (1.5u, u));
    label.top(btex $k$ etex, (3.5u, u));
endfig;

end


