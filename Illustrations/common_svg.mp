prologues := 3;
if scantokens(mpversion) > 1.005:
  outputtemplate :=
else:
  filenametemplate
fi
"%j.svg";

% REQUIRES mpost >= 1.200
outputformat := "svg";


input ../crfuncs;
input TEX;
