input ../common;


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

    drawarrow origin -- (u - r, 0);
    drawarrow (u + r, 0) -- (3u -r, 0);
    drawarrow (3u + r, 0) -- (4u - r, 0);
    drawarrow (u, d + r) -- (u, r);
    drawarrow (3u, d + r) -- (3u, r);

    label.ulft(btex $P_i$ etex, origin);
    label.top(btex $k_i$ etex, (u, d+r));
    label.top(btex $k_i$ etex, (3u, d+r));
    label.top(btex $C_i$ etex, 1/2[(u + r, 0), (3u - r, 0)]);
    label.urt(btex $P_i$ etex, (4u-d, 0));
endfig;

end


