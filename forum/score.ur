type score = int

val update = plus

val eq_score = eq_int

val show_score = show_int

val sql_score = sql_prim
val sql_summable_score = sql_summable_int
val nullify_score = @@nullify_prim [int] sql_int

val insightful = 1
val undecided = 0
val inane = -1

fun toInt s = s

fun withUnits s base =
    show s ^ " " ^ (case s of
			1 => base
		      | _ => base ^ "s")
