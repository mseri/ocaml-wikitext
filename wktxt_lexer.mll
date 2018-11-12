{
    open Wktxt_parser

    let newline = ref true

(* Retourne soit [String str], soit [token], suivant si on est en
     début de ligne ou pas.
 *)
    let token_or_str (str, token) =
        if !newline then begin
            newline := false ;
            token
        end
        else begin
            STRING str
        end
}

let cr = '\n'
let white = [ ' ' '\t' ]
let header_str = '='+
let list_str = '*'+
let numlist_str = '#'+
let indent_str = ':'+
let definition_term = ';'
let definition_def = ':'
let italic = "''"
let bold = "'''"
let blockquote_start = "<blockquote>"
let blockquote_end = "</blockquote>"

rule main = parse
    | header_str as s {
        token_or_str (s, HEAD(String.length s))
    }
    | cr {
        print_endline __LOC__ ;
        Lexing.new_line lexbuf ;
        newline := true ;
        main lexbuf
    }
    | white { main lexbuf }
    | eof { EOF }

(*
rule main = parse

  | '='+ as s {
      token_or_str (s, HEAD(String.length s))
    }

  | '\n' {
      print_endline __LOC__ ;
      Lexing.new_line lexbuf ;
      newline := true ;
      main lexbuf
    }

  | _ as c {
      CHAR c
  }

  | eof {
      EOF
    }
*)
