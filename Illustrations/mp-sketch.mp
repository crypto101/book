%D \module
%D   [       file=mp-sketch.mp
%D        version=2013.02.03
%D          title=\CONTEXT\ \METAPOST\ graphics,
%D       subtitle=Sketch drawing,
%D         author=Aditya Mahajan,
%D           date=\currentdate,
%D      copyright={Aditya Mahajan}]

%D This metapost module is inspired by a TeX.SE question:
%D http://tex.stackexchange.com/q/39296/323
%D
%D I thought that it would be fun to implement a similar feature in MetaPost.
%D
%D To use this package in MetaPost:
%D
%D \starttyping
%D    input mp-sketch;
%D    
%D    beginfig(1)
%D      sketchypaths; % Make draw and fill sketchy
%D      ...
%D      naturalizepaths; % Restore the value of draw and fill
%D      ...
%D    endfig
%D \stoptyping
%D
%D The code is heavily inspired by Hans Hagen's Metafun macros.
%D
%D The macro \type{sketchypaths} is modeled after \type{visualizepaths} from
%D \filename{mp-tool}.

def sketchypaths =
    let draw = sketchdraw ;
    let fill = sketchfill ;
enddef ;

%D Check if \filename{mp-tool} is loaded
if not known context_tool :
  let normaldraw = draw;
  let normalfill = fill;

  def naturalizepaths =
      let fill = normalfill ;
      let draw = normaldraw ;
  enddef ;
fi

%D The variable \type{sketch_amount} determines the amount of randomness in the
%D drawing
numeric sketch_amount; sketch_amount := 3bp;

%D The macro \type{sketchdraw} randomized the path before drawing it. The 
%D \type{expr} ... \type{text} trick is copied from the definition of 
%D \type{drawarrow}
def sketchdraw expr p =
  do_sketchdraw(p if (path p): randomized sketch_amount fi)
enddef;

def do_sketchdraw(expr p) text t =
    normaldraw p t ;
enddef;

%D The macro \type{sketchfill} randomizes the path before filling it.
def sketchfill expr p =
  do_sketchfill(p if (path p): randomized sketch_amount fi)
enddef ;

def do_sketchfill(expr p) text t =
    normalfill p t ;
enddef ;

endinput;

% Modified example from
% http://tex.loria.fr/prod-graph/zoonekynd/metapost/metapost.html

beginfig(1)
  pair A,B,C,O;
  A=(0,0); B=(3cm,0); C=(1cm,2cm);

  O - 1/2[B,C] = whatever * (B-C) rotated 90;
  O - 1/2[A,B] = whatever * (A-B) rotated 90;

  sketchypaths;
  sketch_amount := 5bp;
  draw A--B--C--cycle;

  draw O withpen pencircle scaled 4bp;

  sketch_amount := 2bp;
  draw fullcircle scaled 2abs(O-A) shifted O;
endfig
