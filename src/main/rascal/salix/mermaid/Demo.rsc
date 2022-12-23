module salix::mermaid::Demo

import salix::App;
import salix::Index;
import salix::Core;
import salix::HTML;
import salix::mermaid::ClassDiagram;
import salix::mermaid::FlowChart;

alias Model = bool; // shared in both demos

Model init() = false;

SalixApp[Model] classDiagramApp(str id = "alien") 
  = makeApp(id, init, withIndex("Mermaid", id, cdView), update);

App[Model] classDiagramWebApp()
  = webApp(classDiagramApp(), |project://salix-contrib/src/main/rascal|);

SalixApp[Model] flowChartApp(str id = "alien") 
  = makeApp(id, init, withIndex("FlowChart", id, flView), update);

App[Model] flowChartWebApp()
  = webApp(flowChartApp(), |project://salix/src/main/rascal|);



data Msg = doIt();

Model update(Msg msg, Model m) {
    switch (msg) {
        case doIt(): m = !m;
    }
    return m;
}

void flView(Model m) {

    flowChart("subs", "Three graphs", salix::mermaid::FlowChart::td(), 
      (salix::mermaid::FlowChart::N n, E e, S sub) {
        if (m) {
            n(circc(), "c1", "dit is c1");
        }
        e("c1", "--\>", "a2", "");
        sub("one", (salix::mermaid::FlowChart::N n, E e) {
            e("a1", "--\>", "a2", "hallo");
        });
        sub("two", (salix::mermaid::FlowChart::N n, E e) {
            e("b1", "--\>", "b2", "ik ben");
        });
        sub("three", (salix::mermaid::FlowChart::N n, E e) {
            e("c1", "--\>", "c2", "een label");
        });
    });

    button(onClick(doIt()), "do it");
}



void cdView(Model m) {
    classDiagram("animal", "Animals", (C class, R link, salix::mermaid::ClassDiagram::N note) {
        note("", "From Duck till Zebra");
        note("Duck", "can fly can help in debugging");

        if (m) {
            class("BOOOM", (D decl) {
                ;
            });
        }

        class("Animal", (D decl) { 
            decl("+", "int", "age");
            decl("+", "String", "gender");
            decl("+", "", "isMammal()");
            decl("+", "", "mate()");
        });

        class("Duck", (D decl) {
            decl("+", "String", "beakColor");
            decl("+", "", "swim()");
            decl("+", "", "quack");
        });
        
        class("Fish", (D decl) {
            decl("-", "int", "sizeInFeet");
            decl("-", "", "canEat()");
        });
        
        class("Zebra", (D decl) {
            decl("+", "bool", "is_wild");
            decl("+", "", "run()");
        });

        link("Animal", "\<|--", "Duck");
        link("Animal", "\<|--", "Fish");
        link("Animal", "\<|--", "Zebra");
    });

    button(onClick(doIt()), "Do it");
}