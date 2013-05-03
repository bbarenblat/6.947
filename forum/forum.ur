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

style entryList
style entryMetadata
style entryTitle
style entryBody
style voting

table entry : { Id : int,
		References : option int,
		Class : EntryClass.entryClass,
		Title : option string,
		Body : string,
		Author : Author.usernameOrAnonymous
	      } PRIMARY KEY Id
sequence entryIdS

table vote : { QuestionId : int,
	       Author : Author.username,
	       Value : Score.score
	     }
    CONSTRAINT OneVotePerEntry UNIQUE (QuestionId, Author),
    CONSTRAINT RefersToEntry FOREIGN KEY QuestionId REFERENCES entry(Id)

(* Like query1', but automatically dereferences the field *)
fun queryColumn [tab ::: Name] [field ::: Name] [state ::: Type]
		(q : sql_query [] [] [tab = [field = state]] [])
		(f : state -> state -> state)
		(initial : state)
    : transaction state =
    query q (fn row state => return (f row.tab.field state)) initial

(* Sum all the votes on a single question. *)
fun getScore (questionId : int) : transaction Score.score =
    queryColumn (SELECT Vote.Value FROM vote
				   WHERE Vote.QuestionId = {[questionId]})
		Score.update
		Score.undecided

fun recordVote (value : Score.score) (entryId : int) _formData : transaction page =
    authorOpt <- Author.current;
    (* If the user didn't exist, the user should not have been allowed to vote
    in the first place. *)
    let val author = Author.nameError authorOpt
    in
	dml (INSERT INTO vote (QuestionId, Author, Value)
	     VALUES ({[entryId]}, {[author]}, {[value]}));
	detail entryId
    end

and upvote entryId _formData = recordVote Score.insightful entryId _formData



(***************************** Single questions ******************************)

and detail (id : int) : transaction page =
    authorOpt <- Author.current;
    question <- oneRow1 (SELECT * FROM entry
				  WHERE Entry.Class = {[EntryClass.question]}
				    AND Entry.Id = {[id]});
    score <- getScore id;
    answerBlock <- queryX1' (SELECT * FROM entry
				     WHERE Entry.Class = {[EntryClass.answer]}
				       AND Entry.References = {[Some id]})
			   (fn answer =>
	score <- getScore answer.Id;
	return (
            <xml><p>
	      {[answer.Body]}
	      <span class={entryMetadata}>&mdash;{[answer.Author]} ({[Score.withUnits score "point"]})</span>
	    </p></xml>));
    return (
        Template.generic (Some "Forum") <xml>
         <div class={content}>
           <h2>{[question.Title]}</h2>
           <p>{[question.Body]}</p>
           <p class={entryMetadata}>
	     Asked by {[question.Author]} ({[Score.withUnits score "point"]})
	   </p>
	   {Author.whenIdentified authorOpt
		<xml>
		  <form class={voting}><submit action={upvote id} value="⬆" /></form>
		</xml>}

	   <div>{answerBlock}</div>

           <h3>Your answer</h3>
           <form>
             <textarea {#Body} class={entryBody} /><br />
             Answering as:
             <select {#Author}>
	       {Author.whenIdentified' authorOpt (fn u => <xml><option>{[u]}</option></xml>)}
               <option>Anonymous</option>
             </select>
             <submit action={reply id} value="Answer" />
           </form>
         </div>
       </xml>)

and reply qId submission =
    id <- nextval entryIdS;
    dml (INSERT INTO entry (Id, References, Class, Title, Body, Author)
	 VALUES ({[id]},
	         {[Some qId]},
	         {[EntryClass.answer]},
	         {[None]},
	         {[submission.Body]},
                 {[readError submission.Author]}));
    detail qId


(**************************** Lists of questions *****************************)

fun prettyPrintQuestion entry : transaction xbody =
    score <- getScore entry.Id;
    return (
        <xml><li>
	  <h3><a link={detail entry.Id}>{[entry.Title]}</a></h3>
	  {[entry.Body]}
	  <span class={entryMetadata}>Asked by {[entry.Author]} ({[Score.withUnits score "point"]})</span>
	</li></xml>)

val allQuestions : transaction page =
    questionsList <- queryX1' (SELECT * FROM entry
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
	</xml>)

fun main () : transaction page =
    newestQuestions <- queryX1' (SELECT * FROM entry
					  WHERE Entry.Class = {[EntryClass.question]}
					  ORDER BY Entry.Id DESC
					  LIMIT 5)
				prettyPrintQuestion;
    askerOpt <- Author.current;
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
		{Author.whenIdentified' askerOpt (fn u =>
		     <xml><option>{[u]}</option></xml>)}
		<option>Anonymous</option>
	      </select>
	      <submit action={ask} value="Ask" />
	    </form>
	  </div>
	</xml>)

and ask submission =
    id <- nextval entryIdS;
    dml (INSERT INTO entry (Id, References, Class, Title, Body, Author)
	 VALUES ({[id]},
	         {[None]},
	         {[EntryClass.question]},
	         {[Some submission.Title]},
	         {[submission.Body]},
                 {[readError submission.Author]}));
    main ()

end
