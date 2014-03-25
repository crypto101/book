input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    draw unitsquare xscaled 1.5u yscaled u shifted (1u, 1.5u);
    draw unitsquare xscaled 1.5u yscaled u shifted (1u, -.5u);
    draw unitsquare xscaled 1.5u yscaled u shifted (4.5u, -.5u);
    draw unitsquare scaled u shifted (7u, -.5u);

    drawarrow (6pt, 0) -- (1u, 0);
    drawarrow (1u, 2u) -- (0, 2u) -- (0, 6pt);
    drawarrow (2.5u, 0) -- (3.5u - 6pt, 0);
    drawarrow (3.5u + 6pt, 0) -- (4.5u, 0);
    drawarrow (6u, 0) -- (7u, 0);
    drawarrow (8u, 0) -- (9u, 0);

    drawarrow (3.5u, 6pt) -- (3.5u, 2u) -- (2.5u, 2u);
    

    label(btex $s$ etex, origin);
    label(btex $r$ etex, (3.5u, 0));
    label(btex $\phi(rP)$ etex, (1.75u, 2u));
    label(btex $\phi(sP)$ etex, (1.75u, 0));
    label(btex $\phi(rQ)$ etex, (5.25u, 0));
    label(btex $\Theta$ etex, (7.5u, 0));
endfig;

end
