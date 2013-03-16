(* Menu -- site menu
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

(* Generating nice headings and menus is quite difficult in Ur/Web--there are a
lot of links that the compiler needs to be convinced aren't broken.  I tried
for multiple weeks to get a nice, typesafe solution to this; however, it was
just too brittle.  I've instead settled for a simpler solution--pass the URLs
of the pages the menu links to to 'bless'.  It's a bit sketchy, but it works,
and it's no more unsafe than anything you'd do in a "normal" Web framework. *)

open Styles

con pageName = variant (mapU unit [Main, Forum])

(* Generates the link text *)
fun getName (n : pageName) : xbody =
    match n { Main = fn ()  => <xml>Main</xml>,
	      Forum = fn () => <xml>Forum</xml> }

(* Generates the link URL *)
fun getUrl (n : pageName) : url =
    let val base = "/urweb/6.947"
    in
	match n { Main = fn ()  => bless (base ^ "/index"),
		  Forum = fn () => bless (base ^ "/forum") }
    end

(* Actual title and menu generation code *)
fun header (current : pageName) : xbody =
    let fun item (target : pageName) =
    	    if Variant.eq current target
    	    then <xml><li class={active}>{getName target}</li></xml>
    	    else <xml><li><a href={getUrl target}>{getName target}</a></li></xml>
    in
	<xml>
	  <h1 class={siteTitle}><a href={getUrl (make [#Main] ())}>6.947 &ndash; Functional Programming Project Laboratory</a></h1>
	  <ul class={navBar}>
	    {item (make [#Main] ())}
	    {item (make [#Forum] ())}
	  </ul>
	</xml>
    end
