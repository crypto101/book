input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    %S
    draw unitsquare xscaled 2u yscaled u shifted (0, 3.5u);
    draw unitsquare scaled u shifted (3u, 3.5u);
    draw unitsquare scaled u shifted (5u, 3.5u);
    draw unitsquare xscaled 2u yscaled u shifted (7u, 3.5u);
    %K
    draw unitsquare xscaled 2u yscaled u shifted (0, -.5u);
    draw unitsquare scaled u shifted (3u, -.5u);
    draw unitsquare xscaled 2u yscaled u shifted (5u, -.5u);
    %f(x)
    boxplus(3.5u, 2u, .5u);

    draw (1u, 4.5u) -- (1u, 3.5u);
    draw (8u, 4.5u) -- (8u, 3.5u);
    draw (1u, -.5u) -- (1u,  .5u);
    draw (6u, -.5u) -- (6u,  .5u);

    %wiring
    drawarrow (1u, 2u) -- (3.25u, 2u);
    drawarrow (3.5u, 4u) -- (3.5u, 2.25u);
    drawarrow (3.5u, 0) -- (3.5u, 1.75u);
    drawarrow (3.75u, 2u) -- (5.5u, 2u) -- (5.5u, 2.5u);

    drawarrow (7u, 0) -- (7.5u, 0) -- (7.5u, -1.5u) -- (-.5u, -1.5u) -- (-.5u, 0u) -- origin;

    label.lft(btex $j$ etex, (1u, 2u));
    label.rt(btex $S_i$ etex, (3.5u, 3u));
    label.rt(btex $K_i$ etex, (3.5u, u));
    label(btex $S_j$ etex, (5.5u, 3u));

    label.lft(btex $S$ etex, (-u, 4u));
    label.lft(btex $K$ etex, (-u, 0));

    label(btex $\dots$ etex, (2.5u, 4u));
    label(btex $\dots$ etex, (2.5u, 0u));
    label(btex $\dots$ etex, (4.5u, 4u));
    label(btex $\dots$ etex, (4.5u, 0u));
    label(btex $\dots$ etex, (6.5u, 4u));

    pickup pencircle scaled 4pt;
    drawdot (3.5u, 4u);
    drawdot (3.5u, 0u);
endfig;

end


