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

    //void jsplumb(str name, B block, str width="600px", str height="400xpx") {

    jsplumb("demo", (N drawNode, E drawEdge) {

        drawNode("a", () {
            div(style(("border": "solid")), () {
                span("Node A");
                button("click me");
            });
        });

        drawNode("b", () {
            div(style(("border": "solid")), () {
                span("Node B");
                button("click me");
            });
        });

        if (m.toggle) {
            drawNode("c", () {
                span("BOOOM");
            });
        }

        drawEdge("a", "b", ());
    });
}