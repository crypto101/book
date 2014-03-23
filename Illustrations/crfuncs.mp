%%% xor symbol
def oplus(expr x, y, scale) =
    begingroup;
        draw fullcircle scaled scale shifted (x, y);
        draw (((-0.5, 0) -- (0.5, 0)) scaled scale) shifted(x, y);
        draw (((0, -0.5) -- (0, 0.5)) scaled scale) shifted(x, y);
    endgroup;
enddef;

%%% modular addition symbol
def boxplus(expr x, y, scale) =
    begingroup;
        draw (unitsquare shifted (-0.5, -0.5)) scaled scale shifted (x, y);
        draw (((-0.5, 0) -- (0.5, 0)) scaled scale) shifted(x, y);
        draw (((0, -0.5) -- (0, 0.5)) scaled scale) shifted(x, y);
    endgroup;
enddef;


