(* submit this file
*
*
* CSCI3180 Principles of Programming Languages
*
* --- Declaration ---
* For all submitted files, including the source code files and the written  
* report, for this assignment:
*
* I declare that the assignment here submitted is original except for source
* materials explicitly acknowledged. I also acknowledge that I am aware of
* University policy and regulations on honesty in academic work, and of the
* disciplinary guidelines and procedures applicable to breaches of such policy
* and regulations, as contained in the website
* http://www.cuhk.edu.hk/policy/academichonesty/
*
* Name: <FILL YOUR NAME HERE>
* Student ID: <FILL YOUR STUDENT ID HERE>
* Email Address: <FILL YOUR EMAIL ADDRESS HERE>
*
* Source material acknowledgements (if any):
* 
* Students whom I have discussed with (if any):
*
*)


(* x^2 - 3x + 7 *)
(* val p = Poly (Variable "x", [Term (0, 7), Term (1, ~3), Term (2, 1)]) *)
datatype term_t = Term of int * int
datatype variable_t = Variable of string
datatype poly_t = Poly of variable_t * term_t list
exception VariableMismatch

fun variable (Poly (v, _)) = v
fun term_list (Poly (_, l)) = l
fun expon (Term (e, _)) = e
fun coeff (Term (_, c)) = c


fun add_terms (l1, l2) =
  (* your code here *)
  (* hint: consider implement a helper function (not required) *)
  (*   adjoin_term = fn : term_t * term_t list -> term_t list *)

fun add_poly (Poly (x, l1), Poly (y, l2)) =
  if x = y then 
    Poly (x, add_terms (l1, l2))
  else
    raise VariableMismatch 


fun mul_terms (l1, l2) =
  (* your code here *)
  (* hint: consider implement a helper function (not required) *)
  (*   mul_term_by_terms = fn : term_t * term_t list -> term_t list *)

fun mul_poly (Poly (x, l1), Poly (y, l2)) =
  if x = y then 
    Poly (x, mul_terms (l1, l2))
  else
    raise VariableMismatch 


fun diff_terms l =
  (* your code here *)
  (* hint: consider using foldl (not required) *)

fun diff_poly (Poly (xx, l), x) =
  if x = xx then 
    Poly (x, diff_terms l)
  else
    raise VariableMismatch 


(* helper for calculate the result of a polynomial on a given value x *)
fun eval_poly (Poly (_, l), x) =
  let
    fun pow x e =
      if e = 0 then
        1.0
      else if e mod 2 = 0 then
        pow (x * x) (e div 2)
      else
        x * pow x (e - 1)
  in
    foldl (fn (Term (e, c), sum) => sum + (Real.fromInt c) * (pow x e)) 0.0 l
  end


(* x^2 - 3x + 7 *)
val p = Poly (Variable "x", [Term (0, 7), Term (1, ~3), Term (2, 1)])
(* x *)
val p0 = Poly (Variable "x", [Term (1, 1)])
(* x + 1 *)
val p1 = Poly (Variable "x", [Term (0, 1), Term (1, 1)])
(* x - 1 *)
val p2 = Poly (Variable "x", [Term (0, ~1), Term (1, 1)])
val x = Variable "x"

val add_poly_test_1 = add_poly (p1, p)
  = Poly (Variable "x", [Term (0, 8), Term (1, ~2), Term (2, 1)])

(* x * x = x^2 *)
val mul_poly_test_1 = mul_poly (p0, p0)
  = Poly (Variable "x",[Term (2,1)])

(* x(x + 1) = x^2 + x *)
val mul_poly_test_2 = mul_poly (p0, p1)
  = Poly (Variable "x",[Term (1,1),Term (2,1)])

(* (x + 1)(x - 1) = x^2 -1 *)
val mul_poly_test_3 = mul_poly (p1, p2)
  = Poly (Variable "x",[Term (0,~1),Term (2,1)])

(* (x - 1)(x^2 - 3x + 7)(x + 1) = x^4 - 3x^3 + 6x^2 + 3x - 7 *)
val mul_poly_test_4 = mul_poly (p2, mul_poly (p, p1)) 
  = Poly (Variable "x", [Term (0, ~7), Term (1, 3), Term (2, 6), Term (3, ~3), Term (4, 1)])

val diff_poly_test_1 = diff_poly (p0, x)
  = Poly (Variable "x", [Term (0, 1)])

val diff_poly_test_2 = diff_poly (p2, x)
  = Poly (Variable "x", [Term (0, 1)])

val diff_poly_test_3 = diff_poly (mul_poly (p2, mul_poly (p, p1)), x)
 = Poly (Variable "x", [Term (0, 3), Term (1, 12), Term (2, ~9), Term (3, 4)])
  