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

endfig;

end



