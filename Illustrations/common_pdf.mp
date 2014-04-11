prologues := 3;
if scantokens(mpversion) > 1.005:
  outputtemplate :=
else:
  filenametemplate
fi
"%j.mps";


% define two pens for every illustration -- bookpen for lines & boxes,
% bookdotpen for circuit-style connector dots
pen bookpen;
pen bookdotpen;

bookpen := (pencircle scaled 1pt);
bookdotpen := (pencircle scaled 5pt);

linecap := butt;
linejoin := rounded;

input ../mp-sketch;
input ../crfuncs;
input TEX;

% set to 0 to disable the hand-drawn feeling
sketch_amount := 2.25pt;

pickup bookpen;
sketchypaths;
