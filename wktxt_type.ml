type document = block list
[@@deriving show]

(*
	Un block peut contenir des inlines mais pas d'autres blocks
	Un inline peut être vide ou contenir un autre inline ou simplement une string.

	Les blocs identifiés ici sont :
		Header, List, Numlist, Paragraph, Definition, Blockquote, (Table, align?)
	
	Les inlines sont par exemple les chaines de caractères Bold, italic, ou smallcaps, etc

	renommer "inline" en "block" et créer un type "inline" ?
*)

and block =
  | Header of int * inline list
  | List of inline list 
  | Numlist of int * inline list 
  | Paragraph of inline list
  | Definition of inline list * inline list
  | Blockquote of inline list
  | Table of inline list list
[@@deriving show]

and inline = 
  | Italic of inline list
  | Bold of inline list
  | Smallcaps of inline list
  | String of string 
  | Char of char
[@@deriving show]
(* [@@deriving show] va créer automatique les fonctions
   [show_document], [show_inline], ... *)
