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

    %% sbox stuff
    picture bigsq, bigsqtoo, sbox;
    bigsq := image(
	draw unitsquare scaled 1.25u shifted (1.375u, -2.6275u);
    );
    bigsqtoo := image(
	draw unitsquare scaled 1.25u shifted (1.375u+6u, -2.6275u);
    );
    sbox := image(
	draw unitsquare scaled u shifted (4u, -5.5u);
    );

    unfill bbox bigsq;
    unfill bbox bigsqtoo;
    draw bigsq;
    draw bigsqtoo;
    draw sbox;

    label(btex $a_{2,2}$ etex, (2u, -2u));
    label(btex $b_{2,2}$ etex, (8u, -2u));

    label(btex $\mapsto$ etex , origin) scaled 2 shifted(4.5u, -1.5u);
    label(btex $S$ etex, (4.5u, -5u));

    z1 = .2125[llcorner bigsq,lrcorner bigsq];
    z2 = .25[llcorner bigsqtoo,lrcorner bigsqtoo];
    z3 = .5[llcorner sbox,ulcorner sbox];
    z4 = .5[lrcorner sbox,urcorner sbox];

    drawarrow z1{down} .. {right}z3;
    drawarrow z4{right} .. {up}z2;
endfig;

end

