input ../common;
input TEX;


%%% Drawing scale
numeric u;
u := 1cm;

beginfig(1);
    pickup bookpen;
    numeric c;
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
	     			c := 1 - (x mod 4) / 8;
	     		else:
				c := 1- ((x+y) mod 4) / 8;
  fi
			fill unitsquare scaled .9u shifted (-.45u + s*6u + x*u, -.45u + y*(-u)) withcolor c*white;
			if s=0:
				label(TEX("$a_{" & decimal(y) & ", " & decimal(x) & "}$"), (x*u, y*(-u)) shifted (s*6u, 0));
			else:
				label(TEX("$b_{" & decimal(y) & ", " & decimal((x+y) mod 4) & "}$"), (x*u, y*(-u)) shifted (s*6u, 0));
			fi
		endfor

		if s=0:
			label(TEX("rotate $" & decimal(y) & "$"), origin) scaled .8 shifted (-1.5u, y*(-u));
   		fi
	endfor
    endfor

    label(btex $\mapsto$ etex , origin) scaled 2 shifted(4.5u, -1.5u);
endfig;

end

