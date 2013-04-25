type asker

val anonymous : asker
val namedAsker : string -> asker


(********************************* Instances *********************************)

val eq_asker : eq asker

val show_asker : show asker

(* 'read' producing an 'asker' is guaranteed to never fail, so you can use
'readError' with impunity. *)
val read_asker : read asker

val sql_asker : sql_injectable asker
