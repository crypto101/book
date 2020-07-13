input ../common;
input TEX;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    pickup bookpen;

    %% double grid
    for s=0 upto 1:
	draw unitsquare scaled 4u shifted (-.5u + s * 6u, -3.5u);
	for y=0 upto 3:
		if y<3:
			draw (y*u+.5u, -4u+.5u) shifted(s*6u,0) -- (y*u+.5u, .5u) shifted(s*6u,0);
			draw (-.5u, y*(-u)-.5u) shifted(s*6u,0) -- (3.5u, y*(-u)-.5u) shifted(s*6u, 0);
		fi
		for x=0 upto 3:
			if s=0:
				label(TEX("$a_{" & decimal(y) & ", " & decimal(x) & "}$"), (x*u, y*(-u)) shifted (s*6u, 0));
			else:
				label(TEX("$b_{" & decimal(y) & ", " & decimal(x) & "}$"), (x*u, y*(-u)) shifted (s*6u, 0));
			fi
		endfor
	endfor
    endfor

    %key grid
    draw unitsquare scaled 4u shifted (-.5u, -3.5u - 6u);
    for y=0 upto 3:
	    if y<3:
		draw (y*u+.5u, -4u+.5u) shifted(0,-6u) -- (y*u+.5u, .5u) shifted (0, -6u);
		draw (-.5u, y*(-u)-.5u) shifted(0,-6u) -- (3.5u, y*(-u)-.5u) shifted(0,-6u);
	fi
	for x=0 upto 3:
		label(TEX("$k_{" & decimal(y) & ", " & decimal(x) & "}$"), (x*u, y*(-u)) shifted (0, -6u));
	endfor
    endfor

    %% xor
    picture bigsq, bigsqtoo, bigsqthree, xor;
    bigsq := image(
	draw unitsquare scaled 1.25u shifted (1.375u, -2.6275u);
    );
    bigsqtoo := image(
	draw unitsquare scaled 1.25u shifted (1.375u+6u, -2.6275u);
    );
    bigsqthree := image(
	draw unitsquare scaled 1.25u shifted (1.375u, -2.6275u - 6u);
    );
    xor := image(
	oplus(4.5u,-4.5u,.5u);
    );

    unfill bbox bigsq;
    unfill bbox bigsqtoo;
    unfill bbox bigsqthree;
    draw bigsq;
    draw bigsqtoo;
    draw bigsqthree;
    draw xor;

    label(btex $a_{2,2}$ etex, (2u, -2u));
    label(btex $b_{2,2}$ etex, (8u, -2u));
    label(btex $k_{2,2}$ etex, (2u, -8u));

    label(btex $\mapsto$ etex , origin) scaled 2 shifted(4.5u, -1.5u);

    z1 = .2125[llcorner bigsq,lrcorner bigsq];
    z2 = .25[llcorner bigsqtoo,lrcorner bigsqtoo];
    z3 = .5[llcorner xor,ulcorner xor];
    z4 = .5[lrcorner xor,urcorner xor];
    z5 = .75[urcorner bigsqthree,lrcorner bigsqthree];
    z6 = .5[llcorner xor,lrcorner xor];

    drawarrow z1{down} .. {right}z3;
    drawarrow z4{right} .. {up}z2;
    drawarrow z5{right} .. {up}z6;
endfig;

end

