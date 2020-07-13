input ../config;

prologues := 3;
% svg support REQUIRES mpost >= 1.200
if outputformat = "svg":
  if scantokens(mpversion) > 1.005:
      outputtemplate :=
  else:
      filenametemplate
  fi
  "%j.svg";
else:
  if scantokens(mpversion) > 1.005:
    outputtemplate :=
  else:
    filenametemplate
  fi
  "%j.mps";
fi
