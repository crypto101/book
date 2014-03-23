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
    z1 = origin;
    z2 = (.6u, .175u);
    z3 = (u, .075u);

    mtarrow z1 .. z2 .. z3;

    label.top(btex $E_{k'}$ etex, z2 shifted(-.1u, 0));
endfig;

end

