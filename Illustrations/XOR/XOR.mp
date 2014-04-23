input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    pickup bookpen;
    % first lr
    drawarrow origin -- origin shifted (.75u, 0);
    label.lft(btex $P_i$ etex, origin);
    % second lr
    drawarrow origin shifted(1.25u, 0) -- origin shifted (2u, 0);
    label.rt(btex $C_i$ etex, origin shifted(2u, 0));
    % tb
    drawarrow origin shifted(u, .5u) -- origin shifted (u, .25u);
    label.top(btex $k_i$ etex, origin shifted(u, .5u));
    % xor
    oplus(u, 0, .5u);
endfig;

end
