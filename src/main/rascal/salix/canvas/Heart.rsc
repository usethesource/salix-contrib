module salix::canvas::Heart

import salix::App;
import salix::HTML;
import salix::Index;
import salix::canvas::Canvas;

alias Model = tuple[str x, str y, str color];

Model init(str x, str y) = <x, y, "red">;

SalixApp[Model] heartApp(str id, str x, str y) 
    = makeApp(id, Model() { return init(x, y); }, withIndex("<x> 🥰 <y>", id, view), update);

App[Model] heartWebApp(str x, str y) = webApp(heartApp("heart", x, y), |project://salix/src/main/rascal|);

data Msg = flipColor();

Model update(flipColor(), Model m) = m[color = m.color == "green" ? "red" : "green"];
  
void view(Model m) {
    myCanvas("love", 300, 300, (GC ctx) {
        real x = 150.0;
        real y = 100.0;
        real w = 150.0;
        real h = 100.0;
        real tch = h * 0.3;

        ctx.font("30px sans-serif");
        ctx.fillText(m.x, 20, 160, 100);
        ctx.fillText(m.y, 230, 160, 100);

        ctx.save();
        ctx.beginPath();
        ctx.moveTo(x, y + tch);
        ctx.bezierCurveTo(x, y, x - w / 2, y, x - w / 2, y + tch);
        ctx.bezierCurveTo(x - w / 2, y + (h + tch) / 2, x, y + (h + tch) / 2, x, y + h);
        ctx.bezierCurveTo(x, y + (h + tch) / 2, x + w / 2, y + (h + tch) / 2, x + w / 2, y + tch);
        ctx.bezierCurveTo(x + w / 2, y, x, y, x, y + tch);        
        ctx.closePath();
        ctx.fillStyle(m.color);
        ctx.fill(nonzero());
        ctx.restore();
    });

    button(onClick(flipColor()), "Flip color");
}

