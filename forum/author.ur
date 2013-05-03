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

type usernameOrAnonymous = option string


(*** Instances ***)

val eq_usernameOrAnonymous = Option.eq

val show_usernameOrAnonymous =
    mkShow (
        fn nameOpt =>
           case nameOpt of
               None => "Anonymous"
             | Some nam => nam)

val read_author =
    let fun parse text =
           case text of
               "Anonymous" => None
             | nam => Some nam
    in
       mkRead parse (compose Some parse)
    end

val sql_usernameOrAnonymous = sql_option_prim


(*** Getting the username ***)

val current =
    addressOpt <- getenv (blessEnvVar "SSL_CLIENT_S_DN_Email");
    (* SSL_CLIENT_EMAIL contains the user's entire e-mail address, including
    the "@MIT.EDU" part.  Get rid of the domain name. *)
    return (address <- addressOpt;
    	    usernameAndDomain <- String.split address #"@";
    	    return usernameAndDomain.1)


(******************************* A named user ********************************)

type username = string


(*** Instances ***)

val eq_username = eq_string

val show_username = show_string

val read_username = read_string

val sql_username = sql_prim


(******************************** Converting *********************************)

fun name uOrA = uOrA

val nameError = MyOption.getError

val orAnonymous = Some

(* I can't express this in terms of whenIdentified'--I get a "substitution in
constructor is blocked by a too-deep unification variable." *)
fun whenIdentified [ctx] [use] uOrA text =
    case uOrA of
	None => <xml/>
      | Some u => text

fun whenIdentified' [ctx] [use] uOrA generator =
    case uOrA of
	None => <xml/>
      | Some u => generator u

fun toOptionTag [_use] uOrA =
    case uOrA of
	None => <xml/>
      | Some u => <xml><option>{[u]}</option></xml>
