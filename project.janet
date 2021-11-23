(declare-project
 :name "DotGen"
 :description "Declarative, repeatable, cross-platform bash configuration."
 :dependencies ["https://github.com/janet-lang/jaylib"])

(declare-executable
 :name "test0r"
 :entry "main.janet")
