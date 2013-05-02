(********************************** A user ***********************************)

type usernameOrAnonymous


(*** Instances **)

val eq_usernameOrAnonymous : eq usernameOrAnonymous

val show_usernameOrAnonymous : show usernameOrAnonymous

(* 'read' producing a 'usernameOrAnonymous' is guaranteed to never fail, so you
can use 'readError' with impunity. *)
val read_usernameOrAnonymous : read usernameOrAnonymous

val sql_usernameOrAnonymous : sql_injectable usernameOrAnonymous


(*** Getting the username ***)

(* Grabs username out of MIT certificate. *)
val current : transaction usernameOrAnonymous


(******************************* A named user ********************************)

type username


(*** Instances **)

val eq_username : eq username

val show_username : show username

(* 'read' producing a 'username' is guaranteed to never fail, so you can use
'readError' with impunity. *)
val read_username : read username

val sql_username : sql_injectable username


(******************************** Converting *********************************)

val name : usernameOrAnonymous -> option username

val orAnonymous : username -> usernameOrAnonymous

(* Converts a 'usernameOrAnonymous' to an 'option' tag.  If anonymous, produces
empty XML. *)
val toOptionTag : use ::: {Type} -> usernameOrAnonymous -> xml select use []
