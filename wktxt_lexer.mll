{
    open Wktxt_parser

    let newline = ref true
    let white = [ ' ' '\t' ]+
    let empty_line = [white* '\n']+
    let cr = '\n'
    let header_str = '='+
    let list_str = '*'+
    let numlist_str = '#'+
    let indent_str = ':'+
    let definition_term = ';'
    let definition_def = ':'

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

rule main = parse

  | '='+ as s {
      token_or_str (s, HEADER (String.length s))
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
