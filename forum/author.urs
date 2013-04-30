type author

val anonymous : author
val namedAuthor : string -> author


(********************************* Instances *********************************)

val eq_author : eq author

val show_author : show author

(* 'read' producing an 'author' is guaranteed to never fail, so you can use
'readError' with impunity. *)
val read_author : read author

val sql_author : sql_injectable author
