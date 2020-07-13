input ../mp-sketch;
input ../crfuncs;
input TEX;

% define two pens for every illustration -- bookpen for lines & boxes,
% bookdotpen for circuit-style connector dots
pen bookpen;
pen bookdotpen;

bookpen := (pencircle scaled 1pt);
bookdotpen := (pencircle scaled 5pt);

linecap := butt;
linejoin := rounded;

% set to 0 to disable the hand-drawn feeling ...
sketch_amount := 1.8pt;

pickup bookpen;
% ... or comment out the line beneath.
sketchypaths;


outputformat := "eps";
