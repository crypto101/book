prologues := 3;
if scantokens(mpversion) > 1.005:
  outputtemplate :=
else:
  filenametemplate
fi
"%j-%c.mps";

input TEX;
input cmarrows;

setup_cmarrows(
    arrow_name = "mapstoarrow";
    parameter_file = "cmr10.mf";
    macro_name = "mtarrow");


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    draw fullcircle scaled 10u;

    z1 = (-0.4, .8) scaled 5u;
    z2 = (0.3521, 0.86) scaled 5u;
    z3 = (-0.2563, 0.5598) scaled 5u;
    z4 = (0.6, 0.4) scaled 5u;
    z5 = (-.7, 0.2843) scaled 5u;
    z6 = (0.7439, 0.1636) scaled 5u;
    z7 = (-0.7618, -0.3995) scaled 5u;
    z8 = (0.8585, -0.2089) scaled 5u;

    pickup pencircle scaled 4pt;

    drawdot z1;
    drawdot z2;
    drawdot z3;
    drawdot z4;
    drawdot z5;
    drawdot z6;
    drawdot z7;
    drawdot z8;

    pickup defaultpen;

    label.lft(btex $a$ etex, z1);
    label.rt(btex $b$ etex, z2);
    label.lft(btex $c$ etex, z3);
    label.rt(btex $d$ etex, z4);
    label.lft(btex $e$ etex, z5);
    label.rt(btex $f$ etex, z6);
    label.lft(btex $g$ etex, z7);
    label.rt(btex $h$ etex, z8);

    label(btex $B$ etex, (4u, 4u));

    mtarrow z1 shifted(.18u, .03u){dir 10} .. z2 shifted (-.2u, 0);
    mtarrow z2 shifted(-.1u, -.1u){dir 220} .. {dir 170}z5 shifted (.1u,.0u);
    mtarrow z5 shifted(.03u, .12u){dir 50} .. z3 shifted (-.3u, 0);
    mtarrow z3 shifted(.12u, -.06u){dir 340} .. z8 shifted (-.1u,.1u);
    mtarrow z8 shifted(-.16u, -.02u){dir 200} .. z7 shifted (0.2u,0);
    mtarrow z7 shifted(.12u, .04u) .. z6 shifted (-.1u,-.07u);
    mtarrow z6 shifted(-.1u, .1u) .. z4 shifted (0.06u, -.12u);
    mtarrow z4 shifted(-.16u, -.01u){dir 170} .. z1 shifted (0.1u,-.1u);

endfig;

end



