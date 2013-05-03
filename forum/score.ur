(* Forum.Score -- Upvotes and downvotes
Copyright (C) 2013  Benjamin Barenblat <bbaren@mit.edu>

This file is a part of 6.947.

6.947 is is free software: you can redistribute it and/or modify it under the
terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

6.947 is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with 6.947.  If not, see <http://www.gnu.org/licenses/>. *)

type score = int

val insightful = 1
val undecided = 0
val inane = -1


(********************************* Instances *********************************)

val eq_score = eq_int

val show_score = show_int

val sql_score = sql_prim
val sql_summable_score = sql_summable_int
val nullify_score = @@nullify_prim [int] sql_int


(********************************* Updating **********************************)

val update = plus


(******************************** Conversion *********************************)

fun toInt s = s


(****************************** Pretty-printing ******************************)

fun withUnits s base =
    show s ^ " " ^ (case s of
			1 => base
		      | _ => base ^ "s")
