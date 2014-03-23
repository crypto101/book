prologues := 3;
if scantokens(mpversion) > 1.005:
  outputtemplate :=
else:
  filenametemplate
fi
"%j-%c.mps";

input TEX;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    %blocks
    draw unitsquare xscaled 4u yscaled u;
    draw unitsquare xscaled 5u yscaled u shifted (5.25u, 0);

    %width b-1
    draw (0, 1.25u) -- (0, 1.5u);
    draw (4u, 1.25u) -- (4u, 1.5u);

    drawarrow (2.u - 12pt, 1.375u) -- (0, 1.375u);
    drawarrow (2.u + 11pt, 1.375u) -- (4u, 1.375u);
    label(btex $b-1$ etex, (2u, 1.375u));

    %width 1
    draw (5.25u, 1.25u) -- (5.25u, 1.5u);
    draw (6.25u, 1.25u) -- (6.25u, 1.5u);
    drawarrow (5.75u - 4pt, 1.375u) -- (5.25u, 1.375u);
    drawarrow (5.75u + 4pt, 1.375u) -- (6.25u, 1.375u);
    label(btex $1$ etex, (5.75u, 1.375u));

    %first block
    label(btex $A$ etex, (2u, .5u));

    %second block
    draw (6.25u, 0) -- (6.25u, u) dashed evenly;
    label(btex $s_0$ etex, (5.75u, -.25u));
    label(btex $S$ etex, (7.875u, .5u));

    % curly braces
    label(btex $\lbrace$ etex rotated 90 xscaled 18.5 yscaled 1.25, (3.125u, -.75u));

    % encryption
    drawarrow (3.125u, -.8u) -- (3.125u, -1.25u);
    draw unitsquare scaled u shifted (2.625u, -2.25u);
    label(btex $E$ etex, (3.125u, -1.75u));
    % key
    drawarrow (2.125u, -1.75u) -- (2.625u, -1.75u);
    label.lft(btex $k$ etex, (2.125u, -1.75u));
    % result
    drawarrow (3.125u, -2.25u) -- (3.125u, -2.75u);
    label.bot(btex $C_{R_1}$ etex, (3.125u, -2.75u));

endfig;

end
