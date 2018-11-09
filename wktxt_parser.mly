%{
    open Wktxt_type
%}

%token <int> HEAD
%token <int> LIST
%token <int> NUMLIST
%token BLOCKQUOTE_START
%token BLOCKQUOTE_END
%token TERM
%token DEF
%token BOLD
%token ITALIC
%token HR
%token EMPTY
%token <string> STRING
%token EOF

(* LATER

%token SMALLCAPS    (*HOW TO??*)
%token TABLE
%token TABLE_NAME
%token TABLE_CONTENT

*)

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
