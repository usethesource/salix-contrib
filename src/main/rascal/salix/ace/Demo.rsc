module salix::ace::Demo

import salix::ace::Editor;

import salix::App;
import salix::Core;
import salix::HTML;
import salix::Index;

import String;
import IO;
import util::Math;

alias Model = tuple[bool visible, str code];

Model init() = <true, "var x = function () { return 42; }">;

SalixApp[Model] aceApp(str id = "ace") 
  = makeApp(id, init, withIndex("Ace integration", id, view), update);

App[Model] aceWebApp()
  = webApp(aceApp(), |lib://salix-contrib/src/main/rascal/salix|);

data Msg 
  = changeIt()
  | textUpdated()
  | showHide()
  | editorChange(map[str,value] delta)
  ;

Model update(Msg msg, Model m) {
  switch (msg) {
    case changeIt(): {
      int i = arbInt(size(m.code));
      m.code += "\nvar x = <i>;";
      do(aceSetText("myAce", textUpdated(), m.code));
    }
    case editorChange(map[str,value] delta):
      println("editor change");
    case showHide(): m.visible = !m.visible;
  }
  return m;
}


void view(Model m) {
  h2("Ace elements in Salix");
  if (m.visible) {
    ace("myAce", event=onAceChange(editorChange), code = m.code);
    button(onClick(showHide()), "Hide");
  }
  else {
    button(onClick(showHide()), "Show");
  }
  button(onClick(changeIt()), "Change it");
}
