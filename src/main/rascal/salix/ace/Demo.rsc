module salix::ace::Demo

import salix::ace::Editor;

import salix::App;
import salix::Core;
import salix::HTML;
import salix::Index;

import Set;
import IO;
import util::Math;

alias Model = str;

Model init() = "var x = function () { return 42; }";

SalixApp[Model] aceApp(str id = "ace") 
  = makeApp(id, init, withIndex("Ace integration", id, view), update);

App[Model] aceWebApp()
  = webApp(aceApp(), |lib://salix-contrib/src/main/rascal/salix|);

data Msg 
  = changeIt()
  | myTap(str n)
  ;

Model update(Msg msg, Model m) {
  switch (msg) {
    case changeIt(): {
      int i = arbInt(size(m));
      tuple[str,str] edge = toList(m)[i];
      m += {<edge[1], "a<i>">};
    }
    case myTap(str n):
      println("Node tap: <n>");
  }
  return m;
}


void view(Model m) {
  h2("Ace elements in Salix");
  ace("myAce", code = m);
  button(onClick(changeIt()), "Change it");
}
