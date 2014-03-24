prologues := 3;
if scantokens(mpversion) > 1.005:
  outputtemplate :=
else:
  filenametemplate
fi
"%j.mps";

input TEX;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    %blocks
    draw unitsquare xscaled 5u yscaled u;
    draw unitsquare xscaled 5u yscaled u shifted (5.25u, 0);

    %width
    draw (0, 1.25u) -- (0, 1.5u);
    draw (5u, 1.25u) -- (5u, 1.5u);

    drawarrow (2.5u - 10pt, 1.375u) -- (0, 1.375u);
    drawarrow (2.5u + 10pt, 1.375u) -- (5u, 1.375u);
    label(btex $b$ etex, (2.5u, 1.375u));

    %first block
    draw (4u, 0) -- (4u, u) dashed evenly;
    label(btex $a$ etex, (4.5u, -.25u));
    label(btex $A$ etex, (2u, .5u));

    %second block
    label(btex $S$ etex, (7.875u, .5u));

    % curly braces
    label(btex $\lbrace$ etex rotated 90 xscaled 14.5 yscaled 1.25, (2.5u, -.75u));

    % encryption
    drawarrow (2.5u, -.8u) -- (2.5u, -1.25u);
    draw unitsquare scaled u shifted (2u, -2.25u);
    label(btex $E$ etex, (2.5u, -1.75u));
    % key
    drawarrow (1.5u, -1.75u) -- (2u, -1.75u);
    label.lft(btex $k$ etex, (1.5u, -1.75u));
    % result
    drawarrow (2.5u, -2.25u) -- (2.5u, -2.75u);
    label.bot(btex $C$ etex, (2.5u, -2.75u));

endfig;

end
