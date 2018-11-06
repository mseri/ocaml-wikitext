%{
    open Wktxt_type
%}

%token <int> HEADER
%token <string> STRING
%token <char> CHAR
%token EOF

%start document
%type <Wktxt_type.document> document

%%

document:
  | EOF { None }
  | b = blocks EOF { b }
  ;

blocks:
  | TODO
  ;
(*
document:
| EOF { [] }
| blocks EOF { $1 }
;

blocks:
| block { [$1] }
| block blocks { $1 :: $2 }
;

block:
| HEADER inline { Header ($1, $2) }
;

inline:
| STRING { String $1 }
| CHAR { Char $1 }
;
*)

%%
