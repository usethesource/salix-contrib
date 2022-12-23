module salix::charts::Charts

import vis::Charts; // for the data types
import salix::HTML;
import salix::Node;
import salix::Core;


void charts(str name, Chart c, str width="min(75%,800px)", str height="min(75%,800px)") {
  withExtra(("chart": c), () {
    div(class("salix-alien"), id(name), attr("onclick", 
      "$salix.registerAlien(\'<name>\', chartpatch);"), () {
        script(src("https://cdn.jsdelivr.net/npm/chart.js@4.1.1/dist/chart.umd.min.js"));
        script("function chartpatch(patch) {
               '  console.log(\'patching chart \' + JSON.stringify(patch, null, 3));
               '  let ctx = document.getElementById(\'chart_<name>\');
               '  let x = patch.edits[0].extra;
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
        canvas(style(("width": width, "height": height)), id("chart_" + name));
    });
  });
}

// chart.data = x.data;
//                '  chart.type = x.type;
//                '  chart.options = x.options;
//                '  chart.update();
//                '  