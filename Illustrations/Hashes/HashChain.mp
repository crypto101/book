prologues := 3;
if scantokens(mpversion) > 1.005:
  outputtemplate :=
else:
  filenametemplate
fi
"%j-%c.mps";

input TEX;
input boxes;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    draw unitsquare xscaled 2u yscaled .8u shifted (-u, -.4u);
    draw unitsquare xscaled 3u yscaled .8u shifted (-3.5u, -2.4u);
    draw unitsquare xscaled 3u yscaled .8u shifted (.5u, -2.4u);
    draw unitsquare xscaled 3u yscaled .8u shifted (-3.5u, -4.4u);
    draw unitsquare xscaled 3u yscaled .8u shifted (-5.5u, -6.4u);
    draw unitsquare xscaled 3u yscaled .8u shifted (-1.5u, -6.4u);

    label(btex $H_0 = H(C_0)$ etex, origin);
    label(btex $H_1 = H(H_0\|C_1)$ etex, origin shifted (-2u, -2u));
    label(btex $H_2 = H(H_0\|C_2)$ etex, origin shifted (2u, -2u));
    label(btex $H_3 = H(H_1\|C_3)$ etex, origin shifted (-2u, -4u));
    label(btex $H_4 = H(H_3\|C_4)$ etex, origin shifted (-4u, -6u));
    label(btex $H_5 = H(H_3\|C_5)$ etex, origin shifted (0u, -6u));

    drawarrow (-2u, -1.6u) -- (-.5u, -.4u);
    drawarrow (2u, -1.6u) -- (.5u, -.4u);
    drawarrow (-2u, -3.6u) -- (-2u, -2.4u);
    drawarrow (-4u, -5.6u) -- (-2.5u, -4.4u);
    drawarrow ( 0u, -5.6u) -- (-1.5u, -4.4u);

    drawarrow (-4u, -7.6u) -- (-4u, -6.4u) dashed withdots scaled 0.5;
    drawarrow (-2u, -7.6u) -- (-.5u, -6.4u) dashed withdots scaled 0.5;
    drawarrow (2u, -7.6u) -- (.5u, -6.4u) dashed withdots scaled 0.5;
endfig;

end
