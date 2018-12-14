open Wktxt_type
(* pair_list : ((bool, int), inlines) *)

let rec get_pair_list_from_depth depth pair_list =
  match pair_list with
  | ((_, d), _) :: tl when d > depth -> get_pair_list_from_depth depth tl
  | list -> list

let rec get_blocks depth pair_list prev_type = (* -> block list list *)
  match pair_list with
  | ((cur_type, next_depth), _) :: _ when depth = next_depth && depth = 1 && cur_type <> prev_type ->
    []
  | ((cur_type, next_depth), inlines) :: tl when depth = next_depth ->
    if cur_type <> prev_type then
      prerr_string "Warning : Two list items of different type have been declared on the same level.\n"
      ;
    begin match tl with
      | ((next_type, d'), _) :: _ when next_depth < d' && next_type = Unordered ->
          [Paragraph (List.flatten inlines) ; List (get_blocks (depth + 1) tl Unordered )] ::
            get_blocks depth (get_pair_list_from_depth depth tl) prev_type
      | ((next_type, d'), _) :: _ when next_depth < d' && next_type = Ordered ->
          [Paragraph (List.flatten inlines) ; NumList (get_blocks (depth + 1) tl Ordered )] ::
            get_blocks depth (get_pair_list_from_depth depth tl) prev_type
      | _ ->
        [Paragraph (List.flatten inlines)] :: get_blocks depth tl prev_type
    end
  | ((next_type, next_depth), _) :: tl when depth < next_depth && next_type = Unordered ->
    [List (get_blocks (depth + 1) pair_list Unordered)] :: get_blocks depth tl prev_type
  | ((next_type, next_depth), _) :: tl when depth < next_depth && next_type = Ordered ->
    [NumList (get_blocks (depth + 1) pair_list Ordered)] :: get_blocks depth tl prev_type
  | _ -> []

let rec parse_list l =
  let rec get_next_list l list_type =
    match l with
    | [] -> []
    | ((next_type, next_depth), _) :: _ when next_type <> list_type && next_depth = 1 -> l
    | _ :: tl -> get_next_list tl list_type
  in match l with
  | [] -> []
  | ((next_type, _), _) :: _ when next_type = Ordered ->
    NumList (get_blocks 1 l Ordered) :: parse_list (get_next_list l Ordered)
  | _ ->
    List (get_blocks 1 l Unordered) :: parse_list (get_next_list l Unordered)

let rec get_next_term_list l depth =
  match l with
  | ((cur_type, cur_depth),_) :: tl when cur_type = Description || cur_depth > depth ->
    get_next_term_list tl depth
  | list -> list

let rec get_descriptions l depth :(block list)=
  match l with
  | ((cur_type, cur_depth), inlines) :: tl when cur_type = Description && cur_depth = depth ->
    Paragraph (List.flatten inlines) :: get_descriptions tl depth
  | ((_, cur_depth), _) :: tl when cur_depth > depth ->
    DefList (get_def_blocks l (depth + 1)) ::
      get_descriptions (get_pair_list_from_depth depth tl) depth
  | _ -> []

and get_def_blocks l depth :(def_block list)=
  match l with
  | ((cur_type, cur_depth), inlines) :: tl when cur_type = Term && cur_depth = depth ->
    (List.flatten inlines, get_descriptions tl depth) :: 
      get_def_blocks (get_next_term_list tl depth) depth
  | ((_, cur_depth), _) :: tl when cur_depth >= depth ->
    ([], get_descriptions l depth) :: get_def_blocks (get_next_term_list tl depth) depth
  | _ -> []

  
let rec get_table_line line :(table_block list)=
  match line with
  | (cell_type, inlines) :: tl when cell_type = TableHeader -> TableHead (List.flatten inlines) :: get_table_line tl
  | (_, inlines) :: tl -> TableItem (List.flatten inlines) :: get_table_line tl
  | _ -> []
