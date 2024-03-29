module salix::jsplumb::Demo

import salix::App;
import salix::Core;
import salix::HTML;
import salix::Index;

import salix::jsplumb::JSPlumb;
import util::Math;
import IO;


SalixApp[Model] jsplumbApp(str id = "jsplumb") 
  = makeApp(id, init, withIndex("jsplumb", id, view), update);

App[Model] jsplumbWebApp()
  = webApp(jsplumbApp(), |project://salix/src/main/rascal|);

alias Model = tuple[bool toggle];

Model init() = <false>;

data Msg 
  = doIt()
  ;

Model update(Msg msg, Model m) {
    switch (msg) {
        case doIt(): m.toggle = !m.toggle;
    }
    return m;
}



void view(Model m) {
    h2("JSPlumb demo");
    button(onClick(doIt()), "Do it");

    jsplumb("demo", (N drawNode, E drawEdge) {

        drawNode("a", () {
            div(style(("border": "solid")), () {
                span("Node A <m.toggle>");
                button(onClick(doIt()), "click me");
            });
        });

        drawNode("b", () {
            div(style(("border": "solid")), () {
                span("Node B <m.toggle>");
                button(onClick(doIt()), "click me");
            });
        });

        if (m.toggle) {
            drawNode("c", () {
                span("BOOOM");
            });
            drawEdge("b", "c");
        }

        drawEdge("a", "b");
    });
}