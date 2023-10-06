module salix::canvas::Demo

import salix::canvas::Canvas;

import salix::App;
import salix::HTML;
import salix::Core;
import salix::Index;


alias Model = tuple[str color, list[str] colors, MouseXY lastClick];

Model init() = <"green", ["green"], <<0,0>, <0,0>, <0,0>, <0,0>, <0,0>>>;

SalixApp[Model] canvasApp(str id = "canvasApp") 
  = makeApp(id, init, withIndex("Canvas", id, view), update);

App[Model] canvasWebApp()
  = webApp(canvasApp(), |project://salix/src/main/rascal|);

data Msg 
  = flipColor()
  | mouseClick(MouseXY coords)
  ;

Model update(Msg msg, Model m) {
  switch (msg) {
    case flipColor(): {
        m.color = m.color == "green" ? "red" : "green";
        m.colors += [m.color];
    }
    case mouseClick(MouseXY xy): {
        m.lastClick = xy;
    }
  }
  return m;
}


void view(Model m) {
  h2("Canvas elements in Salix");
  h3("Last click: <m.lastClick>");
  ul(() {
    for (str c <- m.colors) {
        li(c);
    }
  });
  myCanvas("mycanvas", 120, 120, [onClickXY(mouseClick)], (GC ctx) {
    ctx.fillStyle(m.color);
    ctx.fillRect(10, 10, 100, 100);
  });
  button(onClick(flipColor()), "Flip color");
}
