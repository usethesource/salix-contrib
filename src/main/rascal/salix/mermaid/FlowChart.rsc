module salix::mermaid::FlowChart

import salix::mermaid::Mermaid;

import String;
import Node;

alias S = void(str, void(N, E)); // subgraphs; should be self recursive on FL; does not pass (run-time) type checker.

alias FL = void(N, E, S);

alias N = void(Shape, str, str);

alias E = void(str, str, str, str);

data Dir
  = td() | bt() | lr() | rl();

data Shape
  = square() | round() | stadium() | sub() | cyl() | circ() | asym() | rhombus()
  | hexa() | paral() | altParal() | trap() | circc();

str label2shape(Shape shape, str txt) {
    txt = "\"<txt>\"";
    switch (shape) {
        case square(): return "[<txt>]";
        case round(): return "(<txt>)";
        case stadium(): return "([<txt>])";
        case sub(): return "[[<txt>]]";
        case cyl(): return "[(<txt>)]";
        case circ(): return "((<txt>))";
        case asym(): return "\><txt>]";
        case rhombus(): return "{<txt>}";
        case hexa(): return "{{<txt>}}";
        case paral(): return "[/<txt>/]";
        case altParal(): return "[\\<txt>\\]";
        case trap(): return "[\\<txt>/]";
        case circc(): return "(((<txt>)))";
    }
    throw "unknown shape: <shape>";
}

void flowChart(str flname, str title, Dir dir, FL block) {
  str diagram = "---\n<title>\n---\nflowchart <toUpperCase(getName(dir))>\n";

  void n(Shape shape, str id, str txt) {
    diagram += "\t<id><label2shape(shape, txt)>\n";
  }

  void e(str from, str via, str to, str label) {
    str l = label != "" ? "|<label>|" : "";
    diagram += "\t<from> <via> <l><to>\n";
  }

  void subgraph(str sname, void(N, E) sub) {
    diagram += "\tsubgraph <sname>\n";
    sub(n, e);
    diagram += "\tend\n";
  }

  block(n, e, subgraph);

  mermaid(flname, diagram);

}
