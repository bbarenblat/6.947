type score

val insightful : score
val undecided : score
val inane : score


(********************************* Instances *********************************)

val eq_score : eq score

val show_score : show score

val sql_score : sql_injectable score
val sql_summable_score : sql_summable score
val nullify_score : nullify score (option score)


(********************************* Updating **********************************)

val update : score -> score -> score


(******************************** Conversion *********************************)

val toInt : score -> int


(****************************** Pretty-printing ******************************)

val withUnits : score -> string -> string
