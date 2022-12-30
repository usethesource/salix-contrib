module salix::ace::Editor

import salix::HTML;
import salix::Node;
import salix::Core;


private str ACE_SRC = "https://cdnjs.cloudflare.com/ajax/libs/ace/1.14.0/ace.js";
private str ACE_INTEGRITY = "sha512-WYlXqL7GPpZL2ImDErTX0RMKy5hR17vGW5yY04p9Z+YhYFJcUUFRT31N29euNB4sLNNf/s0XQXZfzg3uKSoOdA==";


alias AceAddons = map[str, tuple[str src, str integrity]];

public AceAddons ACE_THEMES = (
    "ace/theme/monokai": <"https://cdnjs.cloudflare.com/ajax/libs/ace/1.14.0/theme-monokai.min.js", 
        "sha512-vH1p51CJtqdqWMpL32h5B9600achcN1XeTfd31hEcrCcCb5PCljIu7NQppgdNtdsayRQTnKmyf94s6HYiGQ9BA==">
);

public AceAddons ACE_MODES = (
    "ace/mode/javascript": <"https://cdnjs.cloudflare.com/ajax/libs/ace/1.14.0/mode-javascript.min.js", 
        "sha512-N2S1El10H86udVD5C2GpUwuXhEkdb3HrqQFYs+PG9G1zBwhd1cwROCG3XYtCr6KL3/XTku53GbWNXFoP0Ur7Gw==">
);


str initCode(str name, str theme, str mode) 
  = "var <name>$editor = ace.edit(\'<name>_editor\');
    '<name>$editor.setTheme(\'<theme>\');
    '<name>$editor.session.setMode(\'<mode>\');
    '$salix.registerAlien(\'<name>\', p =\> <name>$acepatch(<name>$editor, p), {aceSetText_<name>: args =\> {<name>$editor.setValue(args.code); return {type: \'nothing\'};}});";



// TODO: make Msg(str) the type, to give back the name of the editor.
Cmd aceSetText(str name, Msg msg, str code)
  = command("aceSetText_<name>", encode(msg), args = ("code": code));


// delta = {"start":{"row":0,"column":34},"end":{"row":1,"column":0},"action":"insert","lines":["",""],"id":1}
// action can be insert/remove 

Attr onAceChange(Msg(int,int,int,int,str,list[str]) f)
  = event("aceChange", aceDelta(f));

Hnd aceDelta(Msg(int,int,int,int,str,list[str]) delta2msg) = handler("aceDelta", encode(delta2msg));

Msg parseMsg("aceDelta", Handle h, map[str,str] p) 
  = applyMaps(h, decode(h, #Msg(int,int,int,int,str,list[str]))(p["srow"], p["scol"], p["erow"], p["ecol"], p["action"], p["lines"]));



void ace(str name, str code="", str theme="ace/theme/monokai", str mode="ace/mode/javascript",
  AceAddons modes=ACE_MODES, AceAddons themes=ACE_THEMES, str width="600px", str height="400px"
  ) {
    
    div(class("salix-alien"), id(name), attr("onClick", initCode(name, theme, mode)), () {
        script(src(ACE_SRC), \type("text/javascript"), integrity(ACE_INTEGRITY), crossorigin("anonymous"), referrerpolicy("no-referrer"));
        script(src(modes[mode].src), integrity(modes[mode].integrity), crossorigin("anonymous"), referrerpolicy("no-referrer"));
        script(src(themes[theme].src), integrity(themes[theme].integrity), crossorigin("anonymous"), referrerpolicy("no-referrer"));
        script("function <name>$acepatch(editor, patch) {
               '  console.log(JSON.stringify(patch));
               '  editor.session.on(\'change\', function (delta) {
               '     console.log(JSON.stringify(delta));
               '  });
               '}
               '");
        //("position": "absolute", "top": "0", "right": "0", "bottom": "0", "left": "0", 
        div(style(("width": width, "height": height)),
          id("<name>_editor"), code);
    });

}

/*
if (patch.patches[0] && patch.patches[0].patches[0]) {
               '    let x = patch.patches[0].patches[0].edits[0].contents;
               '    editor.setValue(x);
               '  }
               '  else {
               '    console.log(\'No text change\');
               '  }
               */