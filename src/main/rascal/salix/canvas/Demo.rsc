module salix::canvas::Demo

import salix::canvas::Canvas;

import salix::App;
import salix::HTML;
import salix::Core;
import salix::Index;

alias Model = tuple[str color];

Model init() = <"green">;

SalixApp[Model] canvasApp(str id = "canvasApp") 
  = makeApp(id, init, withIndex("Canvas", id, view), update);

App[Model] canvasWebApp()
  = webApp(canvasApp(), |project://salix/src/main/rascal|);

data Msg 
  = flipColor()
  ;

Model update(Msg msg, Model m) {
  switch (msg) {
    case flipColor(): {
        if (m.color == "green") {
            m.color = "red";
        }
        else {
            m.color = "green";
        }
    }
  }
  return m;
}


void view(Model m) {
  h2("Canvas elements in Salix");
  myCanvas("mycanvas", 120, 120, (GC ctx) {
    ctx.fillStyle(m.color);
    ctx.fillRect(10, 10, 100, 100);
  });
  button(onClick(flipColor()), "Flip color");
}