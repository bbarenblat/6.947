(* Forum -- forum subapp
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

functor Make(Template : sig
    val generic : option string -> xbody -> page
end) = struct

open Styles

table question : { Id : int,
		   Title : string,
		   Body : string,
		   Asker : option string (* 'None' if anonymous *)
		 } PRIMARY KEY Id
sequence questionIdS

fun prettyPrintQuestion row : xbody =
    <xml>
      <p>{[row.Question.Title]}: {[row.Question.Body]} (asked by {[row.Question.Asker]})</p>
    </xml>

fun main () : transaction page =
    newestQuestions <- queryX (SELECT * FROM question) prettyPrintQuestion;
    return (
        Template.generic (Some "Forum") <xml>
	  <div class={content}>
	    <p>All questions:</p>
	    {newestQuestions}
	    <p>Ask a new question:</p>
	    <form>
	      <textbox {#Title} size=80 /><br />
	      <textarea {#Body} rows=12 cols=80 /><br />
	      <submit action={ask} value="Ask" />
	    </form>
	  </div>
	</xml>
    )

and ask submission =
    id <- nextval questionIdS;
    dml (INSERT INTO question (Id, Title, Body, Asker)
	 VALUES ({[id]}, {[submission.Title]}, {[submission.Body]}, {[Some "test user"]}));
    main ()

end
