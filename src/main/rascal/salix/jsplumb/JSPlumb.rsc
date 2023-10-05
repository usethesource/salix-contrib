module salix::jsplumb::JSPlumb

import salix::HTML;
import salix::Node;
import salix::Core;


import Node;
import lang::json::IO;
import String;

private str JSPLUMB_SRC = "https://cdnjs.cloudflare.com/ajax/libs/jsPlumb/5.13.6/jsplumb.bundle.js";
private str JSPLUMB_INTEGRITY = "sha512-i2NtWYs2gs+Olnv5DZ5ax2rXhIlhDYxjdnzfufYzE8MBRUEte/mtGYU8P31Aya3+aVJuKlVaYOjywE9iIOuYBQ==";

alias N = void(str id, void() block);

alias E = void(str from, str to);

alias B = void(N, E);

/*

patch (degrades to init):

ids = [];
for (elt in shadowdiv with class <name>_jsplumb_node) {
    if js_plumb_div has element X with id == elt.id {
        update contents of X with contents of elt
    }
    else {
        copy into jsplumb_div;
        jsplumb.manage(copyOfElt)
    }
    ids += [elt.id]
}
for (elt in jsplumbdiv, with id notin ids) {
    jsplumb.unmanage(elt); // ??
    remove from jsplumbdiv;
}

for (elt in shadowdiv with class <name>_jsplumb_edge) {
    src = getElementById(elt.fromNode)
    trg = getElementById(elt.toNode)
    cons = jsplumb.getConnections(src, trg);
}


*/


Attr node2attr(node n) = attr(getName(n), asJSON(getKeywordParameters(n)));

//https://docs.jsplumbtoolkit.com/community/apidocs/browser-ui.connectorspec
data Connector
  = straight(int stub = 0, int gap = 0)
  | bezier(int curviness = 150)
  | flowchart(int stub = 30, bool alwaysRespectStub = false, int gap = 0, real midpoint = 0.5, int cornerRadius = 0)
  | stateMachine(int margin = 5, int curviness = 10, int proximityLimit = 80)
  ;

// https://docs.jsplumbtoolkit.com/community/lib/anchors
data Anchor
  = top() | topRight() | right() | bottomRight() | bottom() | bottomLeft() | left() | topLeft() | center()
  | autoDefault()
  | perimeter(Shape shape, int anchorCount = 60, int rotation = 0)
  | continuous(list[Face] faces = [salix::jsplumb::JSPlumb::Face::top(), 
        salix::jsplumb::JSPlumb::Face::left(), 
        salix::jsplumb::JSPlumb::Face::right(), 
        salix::jsplumb::JSPlumb::Face::bottom()]) 
  ;

data Shape
  = circle() | ellipse() | triangle() | diamond() | rectangle() | square();

data Face = top() | left() | right() | bottom();

//https://docs.jsplumbtoolkit.com/community/lib/endpoints
data Endpoint
  = dot(int radius = 5, str cssClass = "", str hoverClass = "")
  | rectangle(int width = 20, int height = 20, str cssClass = "", str hoverClass = "")
  | blank()
  ;


str initCode(str name)
  = "<name>$jsPlumbInit(); $salix.registerAlien(\'<name>\', <name>$jsPlumbPatch);";


// TODO: don't use id for node-id, because they should be global in a page. 

void jsplumb(str name, B block, str width="600px", str height="400xpx") {
    void drawNode(str myid, void() block) {
        // NB: the position:absolute is required by jsPlumb
        div(id(myid), style(("position": "absolute")), class("<name>_jsplumb_node"), block);
    }

    void drawEdge(str from, str to, Connector connector = straight(), Anchor anchor = autoDefault()) {
        span(style(("display": "none")), class("<name>_jsplumb_edge")
            , attr("fromNode", from), attr("toNode", to)
            , attr("connector", escape(asJSON(connector), ("\"": "&quot;")))
            , attr("anchor", escape(asJSON(anchor), ("\"": "&quot;"))));
    }

    div(class("salix-alien"), id(name), attr("onClick", initCode(name)), () {
        script(src(JSPLUMB_SRC), \type("text/javascript"), integrity(JSPLUMB_INTEGRITY), crossorigin("anonymous"), referrerpolicy("no-referrer"));

        div(style(("display": "none")), id("<name>_shadow_div"), () {
            block(drawNode, drawEdge);
        });

        div(id("<name>_jsplumb_div"), style(("position": "relative", "width": width, "height": height)));

        script(
            "<name>$jsPlumb = jsPlumbBrowserUI.newInstance({container: document.getElementById(\'<name>_jsplumb_div\')});
            'function syncEvents(from, to) {
            '   if (from.salix_handlers) {
            '       const fromHandlers = from.salix_handlers;
            '       const toHandlers = to.salix_handlers || {};
            '       for (var k in fromHandlers) {
            '           if (fromHandlers.hasOwnProperty(k)) {
            '               if (toHandlers.hasOwnProperty(k)) {
            '                   to.removeEventListener(k, toHandlers[k]);
            '               }
            '               to.addEventListener(k, fromHandlers[k]);
            '               toHandlers[k] = fromHandlers[k];
            '           }
            '       }
            '       for (var k in toHandlers) {
            '           if (toHandlers.hasOwnProperty(k) && !fromHandlers.hasOwnProperty(k)) {
            '               to.removeEventListener(k, toHandlers[k]);
            '               toHandlers[k] = undefined;
            '           }
            '       }
            '       to.salix_handlers = toHandlers;
            '   }
            '   else {
            '       to.salix_handlers = undefined;
            '   }
            '   // assumption: num of children is equal in both from and to
            '   for (let i = 0; i \< from.children.length; i++) {
            '       syncEvents(from.children[i], to.children[i]);
            '   }
            '}
            '
            'function <name>$jsPlumbPatch(patch) {
            '  console.log(JSON.stringify(patch, null, 4));
            '  const shadow = document.getElementById(\'<name>_shadow_div\');
            '  $salix.patchDOM(shadow, patch.patches[0], $salix.appender(shadow));
            '  const real = document.getElementById(\'<name>_jsplumb_div\');
            '  const kids = shadow.children;
            '  const copied = {};
            '  for (let i = 0; i \< kids.length; i++) {
            '       const kid = kids[i];
            '       if (kid.classList.contains(\'<name>_jsplumb_node\')) {
            '           const realKid = real.querySelector(\'#\' + kid.id);
            '           if (realKid) {
            '               realKid.replaceChildren(); // delete kids; let\'s hope we don\'t see this
            '               for (let j = 0; j \< kid.children.length; j++) {
            '                   let kidkid = kid.children[j];
            '                   let copy = kidkid.cloneNode(true);
            '                   realKid.appendChild(copy);    
            '               }
            '               syncEvents(kid, realKid);
            '               copied[kid.id] = realKid;
            '           }
            '           else { // it is a new node, do as init
            '               let realKid = kid.cloneNode(true);
            '               real.appendChild(realKid);
            '               syncEvents(kid, realKid);
            '               <name>$jsPlumb.manage(realKid);
            '               copied[kid.id] = realKid;
            '            }
            '       }
            '  }
            '  // remove removed nodes; NB: real does not contain edge elements
            '  for (let i = 0; i \< real.children.length; i++) {
            '       const kid = real.children[i];
            '       if (kid.classList.contains(\'<name>_jsplumb_node\') && !copied.hasOwnProperty(kid.id)) {
            '           let cons = <name>$jsPlumb.getConnections({source: kid.id});
            '           for (let i = 0; i \< cons.length; i++) {
            '               <name>$jsPlumb.deleteConnection(cons[i]);
            '           }       
            '           cons = <name>$jsPlumb.getConnections({target: kid.id});
            '           for (let i = 0; i \< cons.length; i++) {
            '               <name>$jsPlumb.deleteConnection(cons[i]);
            '           }       
            '           real.removeChild(kid);
            '           i--;   
            '       }     
            '  }
            '  for (let i = 0; i \< kids.length; i++) {
            '       const kid = kids[i];
            '       if (kid.classList.contains(\'<name>_jsplumb_edge\')) {
            '           const from = copied[kid.getAttribute(\'fromNode\')];
            '           const to = copied[kid.getAttribute(\'toNode\')];
            '           const conn = copied[kid.getAttribute(\'connector\')];
            '           if (false) {
            '                
            '           }
            '           else { 
            '               <name>$jsPlumb.connect({source: from, target: to
            '                   , connector: {type: \'Bezier\', options: {curviness: 50}}});
            '           }
            '       }
            '  }
            '}
            'function <name>$jsPlumbInit() {
            '   const shadow = document.getElementById(\'<name>_shadow_div\');
            '   const real = document.getElementById(\'<name>_jsplumb_div\');
            '   const kids = shadow.children;
            '   const copied = {};
            '   <name>$jsPlumb.batch(() =\> {
            '   });
            '}"
        );

    });
}

/*

            '       for (let i = 0; i \< kids.length; i++) {
            '           const kid = kids[i];
            '           if (kid.classList.contains(\'<name>_jsplumb_node\')) {
            '               const n = kid.cloneNode(true);
            '               real.appendChild(n); 
            '               <name>$jsPlumb.manage(n);
            '               copied[n.id] = n;
            '           }
            '       }
            '       for (let i = 0; i \< kids.length; i++) {
            '           const kid = kids[i];
            '           const from = copied[kid.getAttribute(\'fromNode\')];
            '           const to = copied[kid.getAttribute(\'toNode\')];
            '           const conn = copied[kid.getAttribute(\'connector\')];
            '           if (kid.classList.contains(\'<name>_jsplumb_edge\')) {
            '               <name>$jsPlumb.connect({source: from, target: to, connector: conn});
            '           }
            '       }

*/