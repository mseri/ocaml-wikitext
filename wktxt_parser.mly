%{
    open Wktxt_type
%}

%token <int> HEAD
%token <int> LIST
%token <int> NUMLIST
%token BLOCKQUOTE_START
%token BLOCKQUOTE_END
%token STRIKE
%token BOLD
%token ITALIC
%token HR
%token EMPTYLINE
%token <string> STRING
%token EOF

(* LATER

%token SMALLCAPS    (*HOW TO??*)
%token TABLE
%token TABLE_NAME
%token TABLE_CONTENT
%token TERM
%token DEF

*)

%start document
%type <Wktxt_type.document> document

%%

document:
    | b = block* EOF { b }
    | EOF { [] }
    ;

block:
    | t = HEAD i = inline(regular)+ { Header (t, i) }
    | t = LIST i = inline(regular)+ { List (t, i) }
    | t = NUMLIST i = inline(regular)+ { Numlist (t, i) }
    | BLOCKQUOTE_START i = inline(regular)+ BLOCKQUOTE_END { Blockquote i }
    ;

(* INLINES *)

regular:
    | BOLD i = inline(bold)+ BOLD { Bold i }
    | ITALIC i = inline(italic)+ ITALIC { Italic i }
    | STRIKE i = inline(strike)+ STRIKE { Strike i }

bold:
    | ITALIC i = inline(italic)+ ITALIC { Italic i }
    | STRIKE i = inline(strike)+ STRIKE { Strike i }

italic:
    | BOLD i = inline(bold)+ BOLD { Bold i }
    | STRIKE i = inline(strike)+ STRIKE { Strike i }

strike:
    | BOLD i = inline(bold)+ BOLD { Bold i }
    | ITALIC i = inline(italic)+ ITALIC { Italic i }

inline(param):
    | param { $1 }
    | s = STRING { String s }
    ;
%%

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
