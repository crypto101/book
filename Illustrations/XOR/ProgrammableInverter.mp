prologues := 3;
if scantokens(mpversion) > 1.005:
  outputtemplate :=
else:
  filenametemplate
fi
"%j.mps";


%%% Drawing scale
numeric u;
u := 1cm;

%%% IEC-style inverter
beginfig(1);
    draw origin -- (u, 0);
    draw unitsquare xscaled u yscaled 2u shifted(u, -u);
    label.bot(btex $1$ etex, (1.5u, u));
    draw fullcircle scaled .25u shifted(2.125u, 0);
    draw (2.25u, 0) -- (3.5u, 0);

    draw (1.5u, 1.5u) -- (1.5u, u);

    label.urt(btex $P_i$ etex, origin);
    label.ulft(btex $C_i$ etex, (3.5u, 0));
    label.lrt(btex $k_i$ etex, (1.5u, 1.5u));
endfig;

%%% traditional inverter
beginfig(2);
    numeric a;
    numeric h;

    1.25a = u;
    h = sqrt(3) * .5a;

    draw origin -- (u, 0);
    %equilat triang
    draw (u, -.5a) -- (u, .5a) -- (u + h, 0) -- cycle;
    %circ
    draw fullcircle scaled .25u shifted (u + h + .125u, 0);
    draw (u + h + .25u, 0) -- (2u + h + .25u, 0);
    %prog lane
    draw 1/2[(u, .5a), (u + h, 0)] -- 1/2[(u, .5a), (u + h, 0)] shifted (0, u);

    label.urt(btex $P_i$ etex, origin);
    label.ulft(btex $C_i$ etex, (2.25u + h, 0));
    label.lrt(btex $k_i$ etex, 1/2[(u, .5a), (u + h, 0)] shifted (0, u));
endfig;


end


