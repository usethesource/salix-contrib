module salix::jsplumb::JSPlumb

import salix::HTML;
import salix::Node;
import salix::Core;


private str JSPLUMB_SRC = "https://cdnjs.cloudflare.com/ajax/libs/jsPlumb/5.13.6/jsplumb.bundle.js";
private str JSPLUMB_INTEGRITY = "sha512-i2NtWYs2gs+Olnv5DZ5ax2rXhIlhDYxjdnzfufYzE8MBRUEte/mtGYU8P31Aya3+aVJuKlVaYOjywE9iIOuYBQ==";

alias N = void(str id, void() block);

alias E = void(str from, str to, map[str,str] props);

alias B = void(N, E);

str initCode(str name)
  = "var <name>$jsPlumb = jsPlumbBrowserUI.newInstance({container: document.getElementById(\'<name>_jsplumb_div\')});
    'function <name>$jsPlumbPatch(jsPlumb, patch) {
    '  // todo    
    '}
    '<name>$jsPlumb.batch(() =\> {
    '   for (const elt of document.getElementsByClassName(\'<name>_jsplumb_node\')) {
    '       <name>$jsPlumb.manage(elt);
    '   }
    '   for (const elt of document.getElementsByClassName(\'<name>_jsplumb_edge\')) {
    '       <name>$jsPlumb.connect({source: document.getElementById(elt.getAttribute(\'fromNode\')), 
    '                              target: document.getElementById(elt.getAttribute(\'toNode\')),
    '                               connector: \'Straight\'});
    '   }
    '});
    '$salix.registerAlien(\'<name>\', p =\> <name>$jsPlumbPatch(<name>$jsPlumb, p));";


void jsplumb(str name, B block, str width="600px", str height="400xpx") {
    
    void drawNode(str myid, void() block) {
        // NB: the position:absolute is required by jsPlumb
        div(id(myid), style(("position": "absolute")), class("<name>_jsplumb_node"), block);
    }

    void drawEdge(str from, str to, map[str,str] props) {
        span(style(("display": "none")), class("<name>_jsplumb_edge"), attr("fromNode", from), attr("toNode", to));
    }

    div(class("salix-alien"), id(name), attr("onClick", initCode(name)), () {
        script(src(JSPLUMB_SRC), \type("text/javascript"), integrity(JSPLUMB_INTEGRITY), crossorigin("anonymous"), referrerpolicy("no-referrer"));

        div(id("<name>_jsplumb_div"), style(("position": "relative", "width": width, "height": height)), () {
            block(drawNode, drawEdge);
        });
    });
}