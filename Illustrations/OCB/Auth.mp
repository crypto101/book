input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    for i=0 upto 1:
        oplus(4i*u, 5u, .5u);
        draw unitsquare scaled u shifted (4i*u - .5u, 3u - .5u);

        drawarrow(4i*u - 1u, 5u) -- (4i*u - .25u, 5u);

        drawarrow(4i*u - 1u, 3u) -- (4i*u - .5u, 3u);
        drawarrow(4i*u - 1u, 3u) -- (4i*u - .5u, 3u);
        label.lft(btex $k$ etex, (4i*u-u, 3u));
        label(btex $E$ etex, (4i*u, 3u));

        drawarrow(4i*u, 6u) -- (4i*u, 5.25u);
        drawarrow(4i*u, 4.75u) -- (4i*u, 3.5u);
        draw(4i*u, 2.5u) -- (4i*u, 1.25u);
    endfor

    % labels -- by column

    label.top(btex $P_1$ etex, (0u, 6u));
    label.lft(btex $\Delta_1$ etex, (-u, 5u));

    label.top(btex $P_n$ etex, (4u, 6u));
    label.lft(btex $\Delta_n$ etex, (3u, 5u));

    label(btex $\dots$ etex, (2u-3pt, 6u));

    oplus(2u, 0, .5u);
    drawarrow (0u, 1.25u) -- (2u - .25u / sqrt(2), .25u / sqrt(2));
    drawarrow (4u, 1.25u) -- (2u + .25u / sqrt(2), .25u / sqrt(2));

    drawarrow (1.5u, 2.5u) --  (1.5u, 1.25u) -- (2u - .25u * .5, .25u * .5 *sqrt(3)) dashed withdots scaled .5;
    drawarrow (2.5u, 2.5u) -- (2.5u, 1.25u) -- (2u + .25u * .5, .25u * .5 *sqrt(3)) dashed withdots scaled .5;

    drawarrow (2u, -.25u) -- (2u, -.75u);
    label.bot(btex $t_a$ etex, (2u, -.75u));

endfig;

end
