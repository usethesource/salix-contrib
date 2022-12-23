module salix::charts::Demo

import vis::Charts;
import salix::App;
import salix::Core;
import salix::HTML;
import salix::Index;

import salix::charts::Charts;
import util::Math;
import IO;


SalixApp[Model] chartApp(str id = "charts") 
  = makeApp(id, init, withIndex("Charts", id, view), update);

App[Model] chartWebApp()
  = webApp(chartApp(), |project://salix/src/main/rascal|);

alias Model = tuple[lrel[value,value] clicks, ChartData cd];

Model init() = <[], demoData()>;

data Msg 
  = doIt()
  | myClick(value v1, value v2)
  ;

Model update(Msg msg, Model m) {
    switch (msg) {
        case doIt(): m.cd = demoData(n=arbInt(20));
        case myClick(value v1, value v2):
          m.clicks += [<v1, v2>];
    }
    return m;
}



ChartData demoData(int n=20) = chartData({<"<i>" , arbInt(100)> | int i <- [0..n] });

Chart demoChart(ChartData theData, ChartType \type=\bar(), str title="Chart", ChartAutoColorMode colorMode=\data())
  = chart(
            \type=\type,
            \data=theData,
            options=chartOptions(
                responsive=true,
                plugins=chartPlugins(
                    legend=chartLegend(
                        position=top()
                    ),
                    title=chartTitle(
                        display=true,
                        text=title
                    ),
                    colors=chartColors(
                        enabled=true
                    ),
                    autocolors=chartAutoColors(
                        mode=colorMode
                    )
                )
            )
        );

void view(Model m) {
    h2("Charts demo");
    button(onClick(doIt()), "Do it");
    h3("clicks:");
    ul(() {
        for (<value v1, value v2> <- m.clicks) {
            li("Clicked at <v1>, <v2>");
        }
    });
    charts("mychart", demoChart(m.cd), event=onClickChart(myClick));
}