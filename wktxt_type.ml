type document = fragment list
[@@deriving show]

(*
	Un block peut contenir des inlines mais pas d'autres blocks
	Un inline peut être vide ou contenir un autre inline.

	Les blocs identifiés ici sont :
		Header, List, Numlist, Paragraph, Definition, Blockquote, (Table, align?)
	
	Les inlines sont par exemple les chaines de caractères Bold, italic, ou smallcaps, etc
*)

and fragment =
  | Header of int * fragment list
  | List of fragment list 
  | Numlist of int * fragment list 
  | Paragraph of fragment list
  | Definition of fragment list * fragment list
  | Blockquote of fragment list
  | Table of fragment list list
  | Italic of fragment list
  | Bold of fragment list
  | String of string
  | Char of char
[@@deriving show]
(* [@@deriving show] va créer automatique les fonctions
   [show_document], [show_fragment], ... *)
