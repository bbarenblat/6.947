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
open Author

style entryList
style entryMetadata
style entryTitle
style entryBody

table entry : { Id : int,
		Class : EntryClass.entryClass,
		Title : string,
		Body : string,
		Author : author
	      } PRIMARY KEY Id
sequence entryIdS

(* Grabs real name out of MIT certificate. *)
val getName : transaction (option string) =
    getenv (blessEnvVar "SSL_CLIENT_S_DN_CN")


(***************************** Single questions ******************************)

fun detail (id : int) : transaction page =
    authorOpt <- getName;
    queryX (SELECT * FROM entry
		     WHERE Entry.Class = {[EntryClass.question]}
                     AND Entry.Id = {[id]}) (fn q =>
        Template.generic (Some "Forum") <xml>
         <div class={content}>
           <h2>{[q.Entry.Title]}</h2>
           <p>{[q.Entry.Body]}</p>
           <p class={entryMetadata}>Asked by {[q.Entry.Author]}</p>

           <h3>Your answer</h3>
           <form>
             <textarea {#Body} class={entryBody} /><br />
             Answering as:
             <select {#Author}>
               {case authorOpt of
                    None => <xml/>
                  | Some nam => <xml><option>{[nam]}</option></xml>}
               <option>Anonymous</option>
             </select>
             <submit action={reply id} value="Answer" />
           </form>
         </div>
       </xml>
    )

and reply qId submission =
    id <- nextval entryIdS;
    dml (INSERT INTO entry (Id, Class, Title, Body, Author)
	 VALUES ({[id]},
	         {[EntryClass.answer]},
	         {[""]},
	         {[submission.Body]},
                 {[readError submission.Author]}));
    detail qId


(**************************** Lists of questions *****************************)

fun prettyPrintQuestion row : xbody =
    <xml>
      <li>
	<h3><a link={detail row.Entry.Id}>{[row.Entry.Title]}</a></h3>
	{[row.Entry.Body]}
	<span class={entryMetadata}>Asked by {[row.Entry.Author]}</span>
      </li>
    </xml>

val allQuestions : transaction page =
    questionsList <- queryX (SELECT * FROM entry
				      WHERE Entry.Class = {[EntryClass.question]}
				      ORDER BY Entry.Id DESC)
			    prettyPrintQuestion;
    return (
        Template.generic (Some "Forum – All questions") <xml>
	  <div class={content}>
	    <h2>All questions</h2>
	    <ul class={entryList}>
	      {questionsList}
	    </ul>
	  </div>
	</xml>
    )

fun main () : transaction page =
    newestQuestions <- queryX (SELECT * FROM entry
					WHERE Entry.Class = {[EntryClass.question]}
					ORDER BY Entry.Id DESC
					LIMIT 5)
			      prettyPrintQuestion;
    askerOpt <- getName;
    return (
        Template.generic (Some "Forum") <xml>
	  <div class={content}>
	    <h2>Latest questions</h2>
	    <ul class={entryList}>
	      {newestQuestions}
	    </ul>
	    <a link={allQuestions}>View all questions</a>

	    <h2>Ask a new question</h2>
	    <form>
	      <textbox {#Title} placeholder="Title" class={entryTitle} /><br />
	      <textarea {#Body} class={entryBody} /><br />
	      Asking as:
	      <select {#Author}>
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
    id <- nextval entryIdS;
    dml (INSERT INTO entry (Id, Class, Title, Body, Author)
	 VALUES ({[id]},
	         {[EntryClass.question]},
	         {[submission.Title]},
	         {[submission.Body]},
                 {[readError submission.Author]}));
    main ()

end
