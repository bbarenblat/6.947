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
open Asker

style questionList
style questionMetadata
style questionEntryTitle
style questionEntryBody

table question : { Id : int,
		   Title : string,
		   Body : string,
		   Asker : asker
		 } PRIMARY KEY Id
sequence questionIdS

(* Grabs real name out of MIT certificate. *)
val getName : transaction (option string) =
    getenv (blessEnvVar "SSL_CLIENT_S_DN_CN")

fun prettyPrintQuestion row : xbody =
    <xml>
      <li>
	<h3>{[row.Question.Title]}</h3>
	{[row.Question.Body]}
	<span class={questionMetadata}>Asked by {[row.Question.Asker]}</span>
      </li>
    </xml>

fun main () : transaction page =
    newestQuestions <- queryX (SELECT * FROM question
					ORDER BY Question.Id DESC
					LIMIT 5)
			      prettyPrintQuestion;
    askerOpt <- getName;
    return (
        Template.generic (Some "Forum") <xml>
	  <div class={content}>
	    <h2>Latest questions</h2>
	    <ul class={questionList}>
	      {newestQuestions}
	    </ul>
	    <h2>Ask a new question</h2>
	    <form>
	      <textbox {#Title} placeholder="Title" class={questionEntryTitle} /><br />
	      <textarea {#Body} class={questionEntryBody} /><br />
	      Asking as:
	      <select {#Asker}>
	        {case askerOpt of
		     None => <xml/>
		   | Some nam => <xml><option>{[nam]}</option></xml>}
		<option>Anonymous</option>
	      </select>
	      <submit action={ask} value="Ask" />
	    </form>
	  </div>
	</xml>
    )

and ask submission =
    id <- nextval questionIdS;
    dml (INSERT INTO question (Id, Title, Body, Asker)
	 VALUES ({[id]}, {[submission.Title]}, {[submission.Body]}, {[readError submission.Asker]}));
    main ()

end
