module salix::cytoscape::Demo

import salix::cytoscape::Cytoscape;

import salix::App;
import salix::Core;
import salix::HTML;
import salix::Index;

import Set;
import util::Math;

alias Model = rel[str, str];

Model init() = {<"a", "b">, <"b", "c">, <"c", "a">};

SalixApp[Model] cytoApp(str id = "alien") 
  = makeApp(id, init, withIndex("Alien", id, view), update);

App[Model] cytoWebApp()
  = webApp(cytoApp(), |project://salix/src/main/rascal|);

data Msg = changeIt();

Model update(Msg msg, Model m) {
  switch (msg) {
    case changeIt(): {
      int i = arbInt(size(m));
      tuple[str,str] edge = toList(m)[i];
      m += {<edge[1], "a<i>">};
    }
  }
  return m;
}


void view(Model m) {
  h2("Alien elements in Salix");
  cyto("mygraph", m);
  button(onClick(changeIt()), "Change it");
}
