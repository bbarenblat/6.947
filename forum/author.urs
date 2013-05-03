(* Forum.User -- User information
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
val nameError : usernameOrAnonymous -> username

val orAnonymous : username -> usernameOrAnonymous

val whenIdentified : ctx ::: {Unit} -> use ::: {Type} ->
		     usernameOrAnonymous -> xml ctx use [] -> xml ctx use []

val whenIdentified' : ctx ::: {Unit} -> use ::: {Type} ->
		      usernameOrAnonymous -> (username -> xml ctx use [])
		      -> xml ctx use []

(* Converts a 'usernameOrAnonymous' to an 'option' tag.  If anonymous, produces
empty XML. *)
val toOptionTag : use ::: {Type} -> usernameOrAnonymous -> xml select use []
