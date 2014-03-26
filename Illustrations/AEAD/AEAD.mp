input ../common;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    draw unitsquare xscaled 5u yscaled u;
    draw (2u, u) -- (2u, 0);

    % labels
    label(btex $A$ etex,  (1u, .5u));
    label(btex $E$ etex,  (3.5u, .5u));

    % curly braces
    label(btex $\lbrace$ etex rotated 90 xscaled 8.5 yscaled 1.25, (3.5u, -.25u));
    label(btex $\lbrace$ etex rotated 90 xscaled 14.5 yscaled 1.25, (2.5u, -.75u));

    %underbrace labels
    label("encrypted", (3.5u, -.5u));
    label("authenticated", (2.5u, -u));
endfig;

end
