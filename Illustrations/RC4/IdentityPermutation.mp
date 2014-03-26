input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    draw unitsquare xscaled 4u yscaled u shifted(0, -.5u);
    draw unitsquare xscaled 2u yscaled u shifted(5u, -.5u);

    draw (1u, .5u) -- (1u, -.5u);
    draw (2u, .5u) -- (2u, -.5u);
    draw (3u, .5u) -- (3u, -.5u);
    draw (6u, .5u) -- (6u, -.5u);

    label(btex $0$ etex, (.5u, 0));
    label(btex $1$ etex, (1.5u, 0));
    label(btex $2$ etex, (2.5u, 0));
    label(btex $3$ etex, (3.5u, 0));
    label(btex $\dots$ etex, (4.5u, 0));
    label(btex $254$ etex, (5.5u, 0));
    label(btex $255$ etex, (6.5u, 0));

    label(btex $0$ etex, (.5u, -.75u));
    label(btex $1$ etex, (1.5u, -.75u));
    label(btex $2$ etex, (2.5u, -.75u));
    label(btex $3$ etex, (3.5u, -.75u));
    label(btex $\dots$ etex, (4.5u, -.75u));
    label(btex $254$ etex, (5.5u, -.75u));
    label(btex $255$ etex, (6.5u, -.75u));
endfig;

end


