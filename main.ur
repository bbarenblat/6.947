(* Main -- main entry point
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

open Styles


(********************************* Template **********************************)

fun generic (pageName : option string) (content : xbody) : xhtml [] [] =
    let val titleString : string =
	    case pageName of
	      | None => "6.947 – Functional Programming Project Laboratory"
	      | Some s => "6.947 – " ^ s
    in
	<xml>
	  <head>
	    <title>{[titleString]}</title>
	    <link rel="stylesheet" type="text/css" href="//bbaren.scripts.mit.edu/urweb/6.947-static/site.css"/>
	  </head>
	  <body>
	    {content}
	    <div class={footer}>
	      <p>
		6.947 is free software: you can redistribute it and/or modify it under the terms of the <a href="//gnu.org/licenses/agpl"><span class={smallCaps}>gnu</span> Affero General Public License</a> as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
	      </p>

	      <p>
		6.947 is distributed in the hope that it will be useful, but <span class={smallCaps}>without any warranty</span>; without even the implied warranty of <span class={smallCaps}>merchantability</span> or <span class={smallCaps}>fitness for a particular purpose</span>.
		See the <span class={smallCaps}>gnu</span> Affero General Public License for more details.
	      </p>

	      <p>
		You can get the 6.947 source code <a href="file:///afs/athena.mit.edu/user/b/b/bbaren/web_scripts/urweb/6.947/">via AFS</a>.
	      </p>
	    </div>
	  </body>
	</xml>
    end


(*********************************** Pages ***********************************)

and main () =
    return (generic None <xml>
      {Menu.header (make [#Main] ())}
      <div class={content}>
	<p>
	  Like <a href="//web.mit.edu/6.115/www/">6.115</a>, 6.947 is a chance to remember why you came to <span class={smallCaps}>mit</span>: to learn and to build.
	  Whereas 6.115 focuses on constructing digital systems from compositions of discrete integrated circuits, however, we’ll be focusing on functional programming &ndash; constructing software systems from compositions of discrete mathematical functions.
	  Prepare to leave behind everything you've ever known about programming and enter a world of functors, combinators, and monads; a world without borders or boundaries; <a href="//www.youtube.com/watch?v=OyRW9uFSmh0">a world where anything is possible</a>.
	</p>
      </div>
    </xml>)

and forum () = forumWorker Forum.main
and forumWorker (f : unit -> xbody) =
    return (generic (Some "Forum") <xml>
      {Menu.header (make [#Forum] ())}
      {f ()}
    </xml>)

