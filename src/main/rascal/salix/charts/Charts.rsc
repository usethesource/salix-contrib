module salix::charts::Charts

import vis::Charts; // for the data types
import salix::HTML;
import salix::Node;
import salix::Core;
import lang::json::IO;

import IO;

Attr onClickChart(Msg(value,value) f) = event("clickChart", targetValues(f));

Hnd targetValues(Msg(value,value) vals2msg) = handler("targetValues", encode(vals2msg));

// removing/adding the event handler dynamically 
// (e.g. based on some flag in the model) won't work.
void charts(str name, Chart c, Attr event=null(), str width="600px", str height="400px") {
  withExtra(("chart": c), () {
    div(class("salix-alien"), id(name), style(("width": width, "height": height)) 
      , attr("onclick", "$salix.registerAlien(\'<name>\', $chartpatch_<name>);"), () {
        script(src("https://cdn.jsdelivr.net/npm/chart.js@4.1.1/dist/chart.umd.min.js"));
        script("function $chartpatch_<name>(patch) {
               '  let ctx = document.getElementById(\'chart_<name>\');
               '  let x = patch.edits[0].extra;
               '  <if (!(event is null)) {>
               '  x.options.onClick = (e) =\> {
               '     const canvasPosition = Chart.helpers.getRelativePosition(e, $chart_<name>);
               '     const dataX = $chart_<name>.scales.x.getValueForPixel(canvasPosition.x);
               '     const dataY = $chart_<name>.scales.y.getValueForPixel(canvasPosition.y);
               '     $salix.send(<asJSON(event.handler)>, {value1: dataX, value2: dataY});
               '  }
               '  <}>
               '  if (!window.$chart_<name>) {
               '     window.$chart_<name> = new Chart(ctx, x);
               '  }
               '  else {
               '    $chart_<name>.data = x.data;
               '    $chart_<name>.type = x.type;
               '    $chart_<name>.options = x.options;
               '    $chart_<name>.update(); 
               '  }
               '}");
        canvas(id("chart_" + name));
    });
  });
}
