input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    pickup bookpen;
    for i=0 upto 2:
        oplus(3i*u, 5u, .5u);
        draw unitsquare scaled u shifted (3i*u - .5u, 3u - .5u);
        oplus(3i*u,  u, .5u);

        drawarrow(3i*u - 1u, 5u) -- (3i*u - .25u, 5u);
        drawarrow(3i*u - 1u, 1u) -- (3i*u - .25u, 1u);

        drawarrow(3i*u - 1u, 3u) -- (3i*u - .5u, 3u);
        drawarrow(3i*u - 1u, 3u) -- (3i*u - .5u, 3u);
        label.lft(btex $k$ etex, (3i*u-u, 3u));
        label(btex $E$ etex, (3i*u, 3u));

        drawarrow(3i*u, 6u) -- (3i*u, 5.25u);
        drawarrow(3i*u, 4.75u) -- (3i*u, 3.5u);
        drawarrow(3i*u, 2.5u) -- (3i*u, 1.25u);

        drawarrow(3i*u, 0.75u) -- (3i*u, 0u);
    endfor

    % labels -- by column

    label.top(btex $P_1$ etex, (0u, 6u));
    label.lft(btex $\Delta_1$ etex, (-u, 5u));
    label.lft(btex $\Delta_1$ etex, (-u, 1u));
    label.bot(btex $C_1$ etex, (0u, 0));

    label.top(btex $P_n$ etex, (3u, 6u));
    label.lft(btex $\Delta_n$ etex, (2u, 5u));
    label.lft(btex $\Delta_n$ etex, (2u, 1u));
    label.bot(btex $C_n$ etex, (3u, 0));

    label.top(btex $X$ etex, (6u, 6u));
    label.lft(btex $\Delta_X$ etex, (5u, 5u));
    label.lft(btex $t_a$ etex, (5u, 1u));
    label.bot(btex $t$ etex, (6u, 0));

    label(btex $\dots$ etex, (1.5u, 6u));
    label.bot(btex $\strut\dots$ etex, (1.5u, 0u));

endfig;

end
