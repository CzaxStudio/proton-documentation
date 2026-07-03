(* Define the types of tokens we can parse *)
type token =
  | TokNum of float
  | TokPlus
  | TokMinus
  | TokTimes
  | TokDiv
  | TokLParen
  | TokRParen
  | TokEOF

(* Lexer: Converts a string into a list of tokens *)
let rec tokenize s i =
  if i >= String.length s then [TokEOF]
  else
    match s.[i] with

    | ' ' | '\t' | '\r' | '\n' -> tokenize s (i + 1)
    | '+' -> TokPlus :: tokenize s (i + 1)
    | '-' -> TokMinus :: tokenize s (i + 1)
    | '*' -> TokTimes :: tokenize s (i + 1)
    | '/' -> TokDiv :: tokenize s (i + 1)
    | '(' -> TokLParen :: tokenize s (i + 1)
    | ')' -> TokRParen :: tokenize s (i + 1)

    | '0'..'9' | '.' ->
        let rec find_end j =
          if j < String.length s && (match s.[j] with '0'..'9' | '.' -> true | _ -> false)
          then find_end (j + 1)
          else j
        in
        let next_i = find_end i in
        let num_str = String.sub s i (next_i - i) in
        TokNum (float_of_string num_str) :: tokenize s next_i
    | _ -> failwith ("Unknown character: " ^ String.make 1 s.[i])

(* Abstract Syntax Tree (AST) definitions *)
type expr =
  | Num of float
  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr

(* Parser: Evaluates tokens based on standard math precedence Rules *)
let rec parse_expr tokens =
  let (e, rest) = parse_term tokens in
  parse_add_sub e rest

and parse_add_sub left tokens =
  match tokens with
  | TokPlus :: rest ->
      let (right, remaining) = parse_term rest in
      parse_add_sub (Add (left, right)) remaining
  | TokMinus :: rest ->
      let (right, remaining) = parse_term rest in
      parse_add_sub (Sub (left, right)) remaining
  | _ -> (left, tokens)

and parse_term tokens =
  let (e, rest) = parse_factor tokens in
  parse_mul_div e rest

and parse_mul_div left tokens =
  match tokens with
  | TokTimes :: rest ->
      let (right, remaining) = parse_factor rest in
      parse_mul_div (Mul (left, right)) remaining
  | TokDiv :: rest ->
      let (right, remaining) = parse_factor rest in
      parse_mul_div (Div (left, right)) remaining
  | _ -> (left, tokens)

and parse_factor tokens =
  match tokens with
  | TokNum n :: rest -> (Num n, rest)
  | TokLParen :: rest ->
      let (e, remaining) = parse_expr rest in
      (match remaining with
       | TokRParen :: next -> (e, next)
       | _ -> failwith "Expected closing parenthesis )")
  | _ -> failwith "Syntax error: expected a number or a parenthesis"

(* Evaluator: Runs the AST to get a final float answer *)
let rec eval e =
  match e with
  | Num n -> n
  | Add (e1, e2) -> eval e1 +. eval e2
  | Sub (e1, e2) -> eval e1 -. eval e2
  | Mul (e1, e2) -> eval e1 *. eval e2
  | Div (e1, e2) -> eval e1 /. eval e2

(* REPL Loop: Reads user input and computes answers *)
let rec main_loop () =
  print_string "Calc> ";
  flush stdout;
  try
    let input = read_line () in
    if input = "exit" || input = "quit" then
      print_endline "Goodbye!"
    else
      let tokens = tokenize input 0 in
      let (ast, rest) = parse_expr tokens in
      if rest <> [TokEOF] then failwith "Unexpected tokens at end of line";
      let result = eval ast in
      print_endline ("= " ^ string_of_float result);
      main_loop ()
  with
  | End_of_file -> print_endline "\nGoodbye!"
  | Failure msg ->
      print_endline ("Error: " ^ msg);
      main_loop ()

let () = 
  print_endline "OCaml Terminal Calculator (Type 'exit' to quit)";
  main_loop ()
