input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    %blocks
    draw unitsquare xscaled 3u yscaled u;
    draw unitsquare xscaled 5u yscaled u shifted (5.25u, 0);

    %width b-2
    draw (0, 1.25u) -- (0, 1.5u);
    draw (3u, 1.25u) -- (3u, 1.5u);

    drawarrow (1.5u - 12pt, 1.375u) -- (0, 1.375u);
    drawarrow (1.5u + 11pt, 1.375u) -- (3u, 1.375u);
    label(btex $b-2$ etex, (1.5u, 1.375u));

    %width 2
    draw (5.25u, 1.25u) -- (5.25u, 1.5u);
    draw (7.25u, 1.25u) -- (7.25u, 1.5u);
    drawarrow (6.25u - 4pt, 1.375u) -- (5.25u, 1.375u);
    drawarrow (6.25u + 4pt, 1.375u) -- (7.25u, 1.375u);
    label(btex $2$ etex, (6.25u, 1.375u));

    %first block
    label(btex $A$ etex, (1.5u, .5u));

    %second block
    draw (6.25u, 0) -- (6.25u, u) dashed evenly;
    draw (7.25u, 0) -- (7.25u, u) dashed evenly;
    label(btex $s_0$ etex, (5.75u, -.25u));
    label(btex $s_1$ etex, (6.75u, -.25u));
    label(btex $S$ etex, (7.875u, .5u));

    % curly braces
    label(btex $\lbrace$ etex rotated 90 xscaled 21.5 yscaled 1.25, (3.625u, -.75u));

    % encryption
    drawarrow (3.625u, -.8u) -- (3.625u, -1.25u);
    draw unitsquare scaled u shifted (3.125u, -2.25u);
    label(btex $E$ etex, (3.625u, -1.75u));
    % key
    drawarrow (2.625u, -1.75u) -- (3.125u, -1.75u);
    label.lft(btex $k$ etex, (2.625u, -1.75u));
    % result
    drawarrow (3.625u, -2.25u) -- (3.625u, -2.75u);
    label.bot(btex $C_{R_2}$ etex, (3.625u, -2.75u));

endfig;

end
