module salix::ace::Demo

import salix::ace::Editor;

import salix::App;
import salix::Core;
import salix::HTML;
import salix::Index;

import String;
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
  | textUpdated()
  | editorChange(map[str,value] delta)
  ;

Model update(Msg msg, Model m) {
  switch (msg) {
    case changeIt(): {
      int i = arbInt(size(m));
      m += "\nvar x = <i>;";
      do(aceSetText("myAce", textUpdated(), m));
    }
    case editorChange(map[str,value] delta):
      println("editor change");
  }
  return m;
}


void view(Model m) {
  h2("Ace elements in Salix");
  ace("myAce", event=onAceChange(editorChange), code = m);
  button(onClick(changeIt()), "Change it");
}
