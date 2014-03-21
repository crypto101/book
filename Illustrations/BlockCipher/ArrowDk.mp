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
    z2 = (.5u, .25u);
    z3 = (u, .1u);

    mtarrow z1 .. z2 .. z3;

    label.top(btex $D_k$ etex, z2);
endfig;

end

