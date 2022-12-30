@license{
  Copyright (c) Tijs van der Storm <Centrum Wiskunde & Informatica>.
  All rights reserved.
  This file is licensed under the BSD 2-Clause License, which accompanies this project
  and is available under https://opensource.org/licenses/BSD-2-Clause.
}
@contributor{Tijs van der Storm - storm@cwi.nl - CWI}

module salix::cytoscape::Cytoscape

import salix::App;
import salix::HTML;
import salix::Node;
import salix::Core;
import salix::Index;

import lang::json::IO;



Attr onNodeClick(Msg(str) f) = event("nodeClick", targetValue(f));

str initCode(str key) = 
    "var cy_<key> = cytoscape({container: document.getElementById(\'cyto_<key>\')});
    '$salix.registerAlien(\'<key>\', edits =\> $cytopatch_<key>(cy_<key>, edits)); 
    '";

void cyto(str name, rel[str, str] graph, Attr event=null(), str width="200px", str height="200px", str \layout="random") {
  withExtra(("graph": graph), () {
    div(class("salix-alien"), id(name), attr("onclick", initCode(name)), () {
        script(src("https://cdn.jsdelivr.net/npm/cytoscape@3.23.0/dist/cytoscape.umd.js"));
        script("function $cytopatch_<name>(cy, patch) {
               '  console.log(\'patching cyto \' + JSON.stringify(patch.edits));
               '  var g = {elements: []};
               '  for (let i = 0; i \< patch.edits[0].extra.length; i++) {
               '    let a = patch.edits[0].extra[i][0];
               '    let b = patch.edits[0].extra[i][1];
               '    g.elements.push({data: {id: a}});
               '    g.elements.push({data: {id: b}});
               '    g.elements.push({data: {id: a + b, source: a, target: b}})
               '  }
               '  g.style = [{selector: \'node\', style: {label: \'data(id)\'}}];
               '  console.log(JSON.stringify(g));
               '  cy.json(g);
               '  cy.on(\'click\', \'node\', function(evt){
               '     let node = evt.target;
               '     $salix.send(<asJSON(event.handler)>, {target: {value: node.id()}});
               '  });
               '  cy.layout({name: \'<\layout>\'}).run();
               '}");
        div(style(("width": width, "height": height)), id("cyto_" + name));
    });
  });
}


