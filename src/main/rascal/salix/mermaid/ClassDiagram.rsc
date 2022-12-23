module salix::mermaid::ClassDiagram

import salix::mermaid::Mermaid;


alias CD = void(C, R, N);

alias C = void(str, void(D));

alias N = void(str, str);

// from, rel+card, to, str label=""
alias R = void(str, str, str);

// modifier, name, type
alias D = void(str, str, str);


void classDiagram(str cdname, str title, CD cd) {
  str diagram = "---\n<title>\n---\nclassDiagram\n";
  

  void klass(str name, void(D) block) {
    diagram += "\tclass <name>{\n\t}\n";
    void decl(str modifier, str typ, str dname) {
        diagram += "\t<name> : <modifier><typ == "" ? "" : "<typ> "><dname>\n";
    }

    block(decl);
  }
  
  void relation(str from, str how, str to) {
    diagram += "\t<from> <how> <to>\n";
  }

  void note(str \for, str txt) {
    // todo: escape \n etc. in txt
    if (\for != "") {
        diagram += "\tnote for <\for> \"<txt>\"\n";
    }
    else {
        diagram += "\tnote \"<txt>\"\n";
    }
  }
  
  cd(klass, relation, note);

  mermaid(cdname, diagram);
}

